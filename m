Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC38C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Nov 2022 07:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiKGHpG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Nov 2022 02:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiKGHpF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Nov 2022 02:45:05 -0500
Received: from mail.steuer-voss.de (mail.steuer-voss.de [85.183.69.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF49120BB;
        Sun,  6 Nov 2022 23:45:00 -0800 (PST)
X-Virus-Scanned: Debian amavisd-new at mail.steuer-voss.de
Received: by mail.steuer-voss.de (Postfix, from userid 1000)
        id 16C5416C1; Mon,  7 Nov 2022 08:44:55 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mail.steuer-voss.de (Postfix) with ESMTP id 141F4ADA;
        Mon,  7 Nov 2022 08:44:55 +0100 (CET)
Date:   Mon, 7 Nov 2022 08:44:55 +0100 (CET)
From:   Nikolaus Voss <nv@vosn.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
cc:     =?ISO-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        David Gstir <david@sigma-star.at>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH] crypto: caam: blob_gen.c: warn if key is insecure
In-Reply-To: <Y2TSRSlefTj6bvYK@gondor.apana.org.au>
Message-ID: <d1b8787c-7c69-43e2-5078-d8affcdd8bd4@vosn.de>
References: <20221019134706.E52E71D10@mail.steuer-voss.de> <Y2TSRSlefTj6bvYK@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Nov 2022, Herbert Xu wrote:
> On Wed, Oct 19, 2022 at 02:44:56PM +0200, Nikolaus Voss wrote:
>>
>> @@ -62,11 +63,13 @@ int caam_process_blob(struct caam_blob_priv *priv,
>>  		      struct caam_blob_info *info, bool encap)
>>  {
>>  	struct caam_blob_job_result testres;
>> +	const struct caam_drv_private *ctrlpriv;
>
> Please keep the declarations sorted by length in reverse.

ok!

>
>> @@ -100,6 +103,11 @@ int caam_process_blob(struct caam_blob_priv *priv,
>>  		goto out_unmap_in;
>>  	}
>>
>> +	ctrlpriv = dev_get_drvdata(jrdev->parent);
>> +	moo = FIELD_GET(CSTA_MOO, ctrlpriv->ctrl->perfmon.status);
>> +	if (moo != CSTA_MOO_SECURE && moo != CSTA_MOO_TRUSTED)
>> +		dev_warn(jrdev, "using insecure test key!\n");
>
> Who is the audience of this warning? Is it possible for this warning
> to be too frequent?

The warning is issued every time the non-volatile hardware test key is 
used to seal/unseal data. This way, the association to the operation is 
strong and is less likely to be ignored by mistake. Further, the system 
security monitor can transition to a non-secure state any time, so one 
warning during boot-up doesn't suffice. IMO, on a typical system, the 
warning occurs with very low frequency, only a few times during 
e.g. authenication or mounting of encrypted volumes.

The audience is the developer who forgets to enable secure boot (HAB) or 
even doesn't know she has to enable HAB to employ the device's unique 
hardware key instead of the test key.

Niko

