From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/2] crypto: remove padding logic from rsa.c
Date: Sat, 27 Feb 2016 19:20:19 -0800
Message-ID: <56D26773.3080502@intel.com>
References: <20160227184005.GA8856@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	balrogg@googlemail.com, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	zohar@linux.vnet.ibm.com, James Morris <jmorris@namei.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:40057 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbcB1DYo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2016 22:24:44 -0500
In-Reply-To: <20160227184005.GA8856@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 02/27/2016 10:40 AM, Herbert Xu wrote:
> Tadeusz Struk <tadeusz.struk@intel.com> wrote:
>>
>> diff --git a/crypto/rsa.c b/crypto/rsa.c
>> index 9a7c9ca..77d737f 100644
>> --- a/crypto/rsa.c
>> +++ b/crypto/rsa.c
>> @@ -16,78 +16,6 @@
>> #include <crypto/algapi.h>
>>
>> /*
>> - * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
>> - */
>> -static const u8 rsa_digest_info_md5[] = {
>> -       0x30, 0x20, 0x30, 0x0c, 0x06, 0x08,
>> -       0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x02, 0x05, /* OID */
>> -       0x05, 0x00, 0x04, 0x10
>> -};
> 
> Where did this come from? It's not in my tree.

These are generated on top of
http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-rsa
Thanks,
-- 
TS
