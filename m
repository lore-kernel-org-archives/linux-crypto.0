From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 1/2] crypto: KEYS: convert public key to the akcipher API
Date: Mon, 24 Aug 2015 10:45:05 -0700
Message-ID: <55DB5821.50807@intel.com>
References: <20150813035433.25108.3065.stgit@tstruk-mobl1>
 <20150813035439.25108.62457.stgit@tstruk-mobl1>
 <3295616.oBrs36mNlq@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:41725 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbbHXRqX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Aug 2015 13:46:23 -0400
In-Reply-To: <3295616.oBrs36mNlq@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On 08/15/2015 11:08 AM, Stephan Mueller wrote:
> Am Mittwoch, 12. August 2015, 20:54:39 schrieb Tadeusz Struk:
> 
> Hi Tadeusz,
> 
>> @@ -41,7 +41,7 @@ struct pkcs7_parse_context {
>> static void pkcs7_free_signed_info(struct pkcs7_signed_info *sinfo)
>> {
>> 	if (sinfo) {
>> -		mpi_free(sinfo->sig.mpi[0]);
>> +		kfree(sinfo->sig.s);
> 
> kzfree?
> 
>> 		kfree(sinfo->sig.digest);
> 
> kzfree?
> 
>> 		kfree(sinfo->signing_cert_id);
>> 		kfree(sinfo);
> 
> kzfree (due to ->msdigest)?
> 

Sorry for late response. I was on vacation.
All these above are module signatures, which are not sensitive,
so no need to zero the buffers on free.
The only thing that is sensitive is the private key,
which is only used for signing modules on make modules_install
and never included in the kernel.
Thanks,
T
