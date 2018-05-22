From: "Natarajan, Janakarajan" <jnataraj@amd.com>
Subject: Re: [PATCH RESEND 1/2] Add DOWNLOAD_FIRMWARE SEV command
Date: Tue, 22 May 2018 09:11:46 -0500
Message-ID: <a9419c51-17fb-55c7-317d-4bd809253e26@amd.com>
References: <8adf44db473ccda6ca626ecdaa058d524af189b7.1525881878.git.Janakarajan.Natarajan@amd.com>
 <20180510172813.GD15817@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
To: Borislav Petkov <bp@suse.de>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180510172813.GD15817@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 5/10/2018 12:28 PM, Borislav Petkov wrote:
> Use a prefix for the subject pls:
>
> Subject: [PATCH RESEND 1/2] crypto: ccp: Add DOWNLOAD_FIRMWARE SEV command
>
> or
>
> Subject: [PATCH RESEND 1/2] crypto/ccp: Add DOWNLOAD_FIRMWARE SEV command
>
> or so.

Okay.


>
> On Wed, May 09, 2018 at 11:18:27AM -0500, Janakarajan Natarajan wrote:
>> The DOWNLOAD_FIRMWARE command, added as of SEV API v0.15, allows the OS
>> to install SEV firmware newer than the currently active SEV firmware.
>>
>> For the new SEV firmware to be applied it must:
>> * Pass the validation test performed by the existing firmware.
>> * Be of the same build or a newer build compared to the existing firmware.
>>
>> For more information please refer to "Section 5.11 DOWNLOAD_FIRMWARE" of
>> https://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf
>>
>> Signed-off-by: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
>> ---
>>   drivers/crypto/ccp/psp-dev.c | 96 +++++++++++++++++++++++++++++++++++++++-----
>>   drivers/crypto/ccp/psp-dev.h |  4 ++
>>   include/linux/psp-sev.h      | 12 ++++++
>>   3 files changed, 102 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
>> index d95ec52..1c78a2e 100644
>> --- a/drivers/crypto/ccp/psp-dev.c
>> +++ b/drivers/crypto/ccp/psp-dev.c
>> @@ -22,11 +22,17 @@
>>   #include <linux/delay.h>
>>   #include <linux/hw_random.h>
>>   #include <linux/ccp.h>
>> +#include <linux/firmware.h>
>>   
>>   #include "sp-dev.h"
>>   #include "psp-dev.h"
>>   
>> +#define SEV_VERSION_CHECK(_maj, _min)			\
>> +		((psp_master->api_major) >= _maj &&	\
>> +		 (psp_master->api_minor) >= _min)
>> +
>>   #define DEVICE_NAME	"sev"
>> +#define SEV_FW_FILE	"amd-sev.fw"
> Can we put this firmware in an amd folder like
>
> 	amd/sev.fw
>
> or so, like we to with the microcode?

Yes. I can do that.


>
> /lib/firmware/amd-ucode/
> ├── microcode_amd.bin
> ├── microcode_amd.bin.asc
> ├── microcode_amd_fam15h.bin
> ├── microcode_amd_fam15h.bin.asc
> ├── microcode_amd_fam16h.bin
> └── microcode_amd_fam16h.bin.asc
>
> It is tidier this way in the fw directory.
>
>>   static DEFINE_MUTEX(sev_cmd_mutex);
>>   static struct sev_misc_dev *misc_dev;
>> @@ -112,6 +118,7 @@ static int sev_cmd_buffer_len(int cmd)
>>   	case SEV_CMD_RECEIVE_UPDATE_DATA:	return sizeof(struct sev_data_receive_update_data);
>>   	case SEV_CMD_RECEIVE_UPDATE_VMSA:	return sizeof(struct sev_data_receive_update_vmsa);
>>   	case SEV_CMD_LAUNCH_UPDATE_SECRET:	return sizeof(struct sev_data_launch_secret);
>> +	case SEV_CMD_DOWNLOAD_FIRMWARE:		return sizeof(struct sev_data_download_firmware);
>>   	default:				return 0;
>>   	}
>>   
>> @@ -378,6 +385,77 @@ void *psp_copy_user_blob(u64 __user uaddr, u32 len)
>>   }
>>   EXPORT_SYMBOL_GPL(psp_copy_user_blob);
>>   
>> +static int get_sev_api_version(void)
> sev_get_api_version()
>
> like the rest.
>
>> +{
>> +	struct sev_user_data_status *status;
>> +	int error, ret;
>> +
>> +	status = &psp_master->status_cmd_buf;
>> +	ret = sev_platform_status(status, &error);
>> +	if (ret) {
>> +		dev_err(psp_master->dev,
>> +			"SEV: failed to get status. Error: %#x\n", error);
>> +		return 1;
>> +	}
>> +
>> +	psp_master->api_major = status->api_major;
>> +	psp_master->api_minor = status->api_minor;
>> +	psp_master->build = status->build;
>> +
>> +	return 0;
>> +}
>> +
>> +/* Don't fail if SEV FW couldn't be updated. Continue with existing SEV FW */
>> +static void sev_update_firmware(struct device *dev)
>> +{
>> +	struct sev_data_download_firmware *data;
>> +	const struct firmware *firmware;
>> +	int ret, error, order;
>> +	struct page *p;
>> +	u64 data_size;
>> +
>> +	ret = request_firmware(&firmware, SEV_FW_FILE, dev);
>> +	if (ret < 0)
>> +		return;
>> +
>> +	/*
>> +	 * SEV FW expects the physical address given to it to be 32
>> +	 * byte aligned. Memory allocated has structure placed at the
>> +	 * beginning followed by the firmware being passed to the SEV
>> +	 * FW. Allocate enough memory for data structure + alignment
>> +	 * padding + SEV FW.
>> +	 */
>> +	data_size = ALIGN(sizeof(struct sev_data_download_firmware), 32);
>> +
>> +	order = get_order(firmware->size + data_size);
>> +	p = alloc_pages(GFP_KERNEL, order);
>> +	if (!p)
>> +		goto fw_err;
>> +
>> +	/*
>> +	 * Copy firmware data to a kernel allocated contiguous
>> +	 * memory region.
>> +	 */
>> +	data = page_address(p);
>> +	memcpy(page_address(p) + data_size, firmware->data, firmware->size);
>> +
>> +	data->address = __psp_pa(page_address(p) + data_size);
>> +	data->len = firmware->size;
>> +
>> +	ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, data, &error);
>> +	if (ret) {
>> +		dev_dbg(dev, "Failed to update SEV firmware: %#x\n", error);
>> +	} else {
>> +		dev_info(dev, "SEV firmware update successful\n");
>> +		get_sev_api_version();
> Call that function in the caller of sev_update_firmware() and in its
> success path. For that, make sev_update_firmware() return success/error
> value.
>
>> +	}
>> +
>> +	__free_pages(p, order);
>> +
>> +fw_err:
>> +	release_firmware(firmware);
>> +}
>> +
>>   static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
>>   {
>>   	struct sev_user_data_pek_cert_import input;
>> @@ -750,7 +828,6 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>>   
>>   void psp_pci_init(void)
>>   {
>> -	struct sev_user_data_status *status;
>>   	struct sp_device *sp;
>>   	int error, rc;
>>   
>> @@ -760,6 +837,12 @@ void psp_pci_init(void)
>>   
>>   	psp_master = sp->psp_data;
>>   
>> +	if (get_sev_api_version())
>> +		goto err;
>> +
>> +	if (SEV_VERSION_CHECK(0, 15))
> That macro could use a readability improvement. This way it doesn't tell
> me what the check is doing. Is it checking whether the version should be
> 0.15 or should it be bigger than 0.15 or what...?
>
> I have to go look at its definition.
>
>> +		sev_update_firmware(psp_master->dev);
> I wonder if we should try to load a new fw *every* time we init the
> driver. I guess so... can't think of something speaking against it right
> now...
>
>> +
>>   	/* Initialize the platform */
>>   	rc = sev_platform_init(&error);
>>   	if (rc) {
>> @@ -767,16 +850,9 @@ void psp_pci_init(void)
>>   		goto err;
>>   	}
>>   
>> -	/* Display SEV firmware version */
>> -	status = &psp_master->status_cmd_buf;
>> -	rc = sev_platform_status(status, &error);
>> -	if (rc) {
>> -		dev_err(sp->dev, "SEV: failed to get status error %#x\n", error);
>> -		goto err;
>> -	}
>> +	dev_info(sp->dev, "SEV API:%d.%d build:%d\n", psp_master->api_major,
>> +		 psp_master->api_minor, psp_master->build);
>>   
>> -	dev_info(sp->dev, "SEV API:%d.%d build:%d\n", status->api_major,
>> -		 status->api_minor, status->build);
>>   	return;
>>   
>>   err:
> But, before we do further games with this, I'm able to trigger the
> following link error with the attached config. So pls sort that out
> first. The idea is that the user should not be able to create a failing
> config.

I have submitted a bugfix for this in the KVM tree.

I can send out a v2 of this patchset with the required changes.

Thanks,
Janak

>
> arch/x86/kvm/svm.o: In function `__sev_issue_cmd':
> /home/boris/kernel/linux/arch/x86/kvm/svm.c:6256: undefined reference to `sev_issue_cmd_external_user'
> arch/x86/kvm/svm.o: In function `sev_unbind_asid':
> /home/boris/kernel/linux/arch/x86/kvm/svm.c:1740: undefined reference to `sev_guest_deactivate'
> /home/boris/kernel/linux/arch/x86/kvm/svm.c:1743: undefined reference to `sev_guest_df_flush'
> /home/boris/kernel/linux/arch/x86/kvm/svm.c:1752: undefined reference to `sev_guest_decommission'
> arch/x86/kvm/svm.o: In function `sev_guest_init':
> /home/boris/kernel/linux/arch/x86/kvm/svm.c:6207: undefined reference to `sev_platform_init'
> arch/x86/kvm/svm.o: In function `sev_launch_start':
> /home/boris/kernel/linux/arch/x86/kvm/svm.c:6302: undefined reference to `psp_copy_user_blob'
> /home/boris/kernel/linux/arch/x86/kvm/svm.c:6290: undefined reference to `psp_copy_user_blob'
> arch/x86/kvm/svm.o: In function `sev_bind_asid':
> /home/boris/kernel/linux/arch/x86/kvm/svm.c:6230: undefined reference to `sev_guest_df_flush'
> /home/boris/kernel/linux/arch/x86/kvm/svm.c:6241: undefined reference to `sev_guest_activate'
> arch/x86/kvm/svm.o: In function `sev_launch_secret':
> /home/boris/kernel/linux/arch/x86/kvm/svm.c:6833: undefined reference to `psp_copy_user_blob'
> /home/boris/kernel/linux/arch/x86/kvm/svm.c:6842: undefined reference to `psp_copy_user_blob'
> arch/x86/kvm/svm.o: In function `sev_hardware_setup':
> /home/boris/kernel/linux/arch/x86/kvm/svm.c:1237: undefined reference to `sev_platform_status'
> make: *** [vmlinux] Error 1
>
> Thx.
>
