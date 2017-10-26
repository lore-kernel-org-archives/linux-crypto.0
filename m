From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 26 Oct 2017 14:26:15 -0500
Message-ID: <bc7254d3-a2d9-e3fd-02a4-164d5e4fb545@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171023092020.GB19523@nazgul.tnic>
 <f58e72e5-8636-2abb-99e9-c58f462463e7@amd.com>
 <20171026135614.GA12359@nazgul.tnic>
 <9258d8e7-b185-01d2-be92-d7d2820c7eb6@amd.com>
 <20171026174427.GB29782@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171026174427.GB29782@nazgul.tnic>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/26/2017 12:44 PM, Borislav Petkov wrote:
> On Thu, Oct 26, 2017 at 11:56:57AM -0500, Brijesh Singh wrote:
>> The variable is used as ref counter.
> 
> ... and it can't be converted to a boolean because...?
> 

SHUTDOWN command unconditionally transitions a platform to uninitialized 
state. The command does not care how many processes are actively using 
the PSP. We don't want to shutdown the firmware while other process is 
still using it.

e.g consider three processes (A, B, C)

Process A:
----------
sev_platform_init()
sev_do_cmd(..)
...
...
sev_do_cmd(..)
...
sev_platform_shutdown()

Process B:
-----------
sev_platform_init()
sev_do_cmd(...)
sev_platform_shutdown()

Process C:
----------
sev_platform_init()
sev_do_cmd(...)
sev_do_cmd(...)
sev_do_cmd(...)
sev_platform_shutdown()

As per the SEV spec section 5.1.2 (platform state machine), several 
commands require that platform should be initialized before issuing the 
actual command. As you can see Process B may finish quickly and SHUTDOWN 
from process B will simply uninitialize the firmware and cause 
unexpected result to process A and C.


>> In your previous reply you comments on global semaphore (fw_init_mutex) and
>> in response I tried to highlight why we need the global semaphore. Did I
>> misunderstood your comment ?
> 
> Yes, what happens if you get preempted while holding the mutex? Will the other
> process be able to do anything?
> 

If other process tries to issue the sev_platform_init/shutdown() then 
they have to wait.

The sev_platform_init() and sev_platform_shutdown() uses the same global 
mutex. See the original code below.

+static int __sev_platform_init(struct sev_data_init *data, int *error)
+{
+	int rc = 0;
+
+	mutex_lock(&fw_init_mutex);
+
+	if (!fw_init_count) {
+		rc = sev_do_cmd(SEV_CMD_INIT, data, error);
+		if (rc)
+			goto unlock;
+	}
+
+	fw_init_count++;
+
+unlock:
+	mutex_unlock(&fw_init_mutex);
+	return rc;
+
+}
+
+int sev_platform_shutdown(int *error)
+{
+	int rc = 0;
+
+	mutex_lock(&fw_init_mutex);
+
+	if (!fw_init_count)
+		goto unlock;
+
+	if (fw_init_count == 1) {
+		rc = sev_do_cmd(SEV_CMD_SHUTDOWN, 0, error);
+		if (rc)
+			goto unlock;
+	}
+
+	fw_init_count--;
+
+unlock:
+	mutex_unlock(&fw_init_mutex);
+	return rc;
+}
