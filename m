From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] crypto: cavium: fix Kconfig dependencies
Date: Tue, 14 Feb 2017 10:26:52 -0800
Message-ID: <47441e97-99be-15e7-ea15-b35a4a827139@infradead.org>
References: <20170214170739.2687818-1-arnd@arndb.de>
 <09cdd8d4-f84b-9664-15e2-4fe923d0b744@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: David Daney <david.daney@cavium.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: David Daney <ddaney@caviumnetworks.com>,
        Arnd Bergmann <arnd@arndb.de>,
        George Cherian <george.cherian@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49738 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751591AbdBNS07 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 13:26:59 -0500
In-Reply-To: <09cdd8d4-f84b-9664-15e2-4fe923d0b744@caviumnetworks.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/14/17 09:09, David Daney wrote:
> On 02/14/2017 09:07 AM, Arnd Bergmann wrote:
>> The driver fails to build if MSI support is disabled:
>>
>> In file included from /git/arm-soc/drivers/crypto/cavium/cpt/cptpf_main.c:18:0:
>> drivers/crypto/cavium/cpt/cptpf.h:57:20: error: array type has incomplete element type 'struct msix_entry'
>>   struct msix_entry msix_entries[CPT_PF_MSIX_VECTORS];
>>                     ^~~~~~~~~~~~
>> drivers/crypto/cavium/cpt/cptpf_main.c: In function 'cpt_enable_msix':
>> drivers/crypto/cavium/cpt/cptpf_main.c:344:8: error: implicit declaration of function 'pci_enable_msix';did you mean 'cpt_enable_msix'? [-Werror=implicit-function-declaration]
>>
>> On the other hand, it doesn't seem to have any build dependency on ARCH_THUNDER,
>> so let's allow compile-testing to catch this kind of problem more easily.
>> The 64-bit dependency is needed for the use of readq/writeq.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/crypto/cavium/cpt/Kconfig | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/cavium/cpt/Kconfig b/drivers/crypto/cavium/cpt/Kconfig
>> index 247f1cbbefc1..cbd51b1aa046 100644
>> --- a/drivers/crypto/cavium/cpt/Kconfig
>> +++ b/drivers/crypto/cavium/cpt/Kconfig
>> @@ -7,7 +7,8 @@ config CRYPTO_DEV_CPT
>>
>>  config CAVIUM_CPT
>>      tristate "Cavium Cryptographic Accelerator driver"
>> -    depends on ARCH_THUNDER
>> +    depends on ARCH_THUNDER || COMPILE_TEST
>> +    depends on PCI_MSI && 64BIT
> 
> 
> Perhaps we should select PCI and PCI_MSI instead.
> 
> These systems cannot function without those.

Then the "depends" (and hence the patch) is correct.

A driver should not enable all of PCI if it is disabled
for some other reason.

>>      select CRYPTO_DEV_CPT
>>      help
>>        Support for Cavium CPT block found in octeon-tx series of
>>
> 


-- 
~Randy
