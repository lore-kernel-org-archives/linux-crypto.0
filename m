From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v2 2/2] integrity: convert digsig to akcipher api
Date: Mon, 14 Dec 2015 06:59:02 -0800
Message-ID: <566ED936.6070801@intel.com>
References: <20151213022614.12730.76645.stgit@tstruk-mobl1>
 <20151213022624.12730.35862.stgit@tstruk-mobl1>
 <1450099487.2702.32.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, dhowells@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44088 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbbLNPCW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Dec 2015 10:02:22 -0500
In-Reply-To: <1450099487.2702.32.camel@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/14/2015 05:24 AM, Mimi Zohar wrote:
> On Sat, 2015-12-12 at 18:26 -0800, Tadeusz Struk wrote:
>> Convert asymmetric_verify to akcipher api.
>>
>> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
>> ---
>>  security/integrity/Kconfig             |    1 +
>>  security/integrity/digsig_asymmetric.c |   10 +++-------
>>  2 files changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
>> index 73c457b..f0b2463 100644
>> --- a/security/integrity/Kconfig
>> +++ b/security/integrity/Kconfig
>> @@ -36,6 +36,7 @@ config INTEGRITY_ASYMMETRIC_KEYS
>>          select ASYMMETRIC_KEY_TYPE
>>          select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
>>          select PUBLIC_KEY_ALGO_RSA
>> +        select CRYPTO_RSA
>>          select X509_CERTIFICATE_PARSER
>>  	help
>>  	  This option enables digital signature verification using
>> diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
>> index 4fec181..5629372 100644
>> --- a/security/integrity/digsig_asymmetric.c
>> +++ b/security/integrity/digsig_asymmetric.c
>> @@ -92,13 +92,9 @@ int asymmetric_verify(struct key *keyring, const char *sig,
>>  	pks.pkey_hash_algo = hdr->hash_algo;
>>  	pks.digest = (u8 *)data;
>>  	pks.digest_size = datalen;
>> -	pks.nr_mpi = 1;
>> -	pks.rsa.s = mpi_read_raw_data(hdr->sig, siglen);
>> -
>> -	if (pks.rsa.s)
>> -		ret = verify_signature(key, &pks);
>> -
>> -	mpi_free(pks.rsa.s);
>> +	pks.s = hdr->sig;
> 
> Thanks!  With this change, my system is now able to boot.
> 
Thanks Mimi.

David, do you have any comments to this patch set? If not could you ACK please.
Thanks,

-- 
TS
