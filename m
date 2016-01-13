From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: sahara: Fill the statesize field
Date: Wed, 13 Jan 2016 11:00:51 -0600
Message-ID: <569682C3.8020408@amd.com>
References: <1452687005-16444-1-git-send-email-festevam@gmail.com>
 <CAOMZO5A2eome5yGV_K9+qOwh9ndu=n71f_Vtee0VowVq0rm40g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	<linux-crypto@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@nxp.com>
To: Fabio Estevam <festevam@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0079.outbound.protection.outlook.com ([207.46.100.79]:6784
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753605AbcAMRA6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2016 12:00:58 -0500
In-Reply-To: <CAOMZO5A2eome5yGV_K9+qOwh9ndu=n71f_Vtee0VowVq0rm40g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 01/13/2016 10:42 AM, Fabio Estevam wrote:
> On Wed, Jan 13, 2016 at 10:10 AM, Fabio Estevam <festevam@gmail.com> wrote:
> 
>> diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
>> index f68c24a..d05d849 100644
>> --- a/drivers/crypto/sahara.c
>> +++ b/drivers/crypto/sahara.c
>> @@ -1260,6 +1260,7 @@ static struct ahash_alg sha_v3_algs[] = {
>>         .export         = sahara_sha_export,
>>         .import         = sahara_sha_import,
>>         .halg.digestsize        = SHA1_DIGEST_SIZE,
>> +       .halg.statesize         = sizeof(struct sahara_ctx),
> 
> Or should this be sizeof(struct sha1_state) instead?

It should actually be the size of the data that your import and export
routines copy. Looking at those it should be sizeof(struct sahara_ctx) +
sizeof(struct sahara_sha_reqctx).

Should the struct sahara_ctx be part of the import and export data,
though?

Tom

> 
>>         .halg.base      = {
>>                 .cra_name               = "sha1",
>>                 .cra_driver_name        = "sahara-sha1",
>> @@ -1287,6 +1288,7 @@ static struct ahash_alg sha_v4_algs[] = {
>>         .export         = sahara_sha_export,
>>         .import         = sahara_sha_import,
>>         .halg.digestsize        = SHA256_DIGEST_SIZE,
>> +       .halg.statesize         = sizeof(struct sahara_ctx),
> 
> Or should this be sizeof(struct sha256_state) instead?
> 
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
