Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AD3C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 03:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 004EF22B42
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 03:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbhATDrV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jan 2021 22:47:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730603AbhATDoj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jan 2021 22:44:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FD7222573;
        Wed, 20 Jan 2021 03:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611114238;
        bh=My3l9mdP5r74fya1/xnAAZLXmhSUL7ojLeSVLOTNDog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DbaWzIoJzMhGisRPoUJyWfFtTpRHz3vN/9bm/lTku5twZIjB9Tm0kXHc/F+wN7Pvm
         whx4u6pCfuZkWKtYE+hmDf6AMiqYY5urEf9BgJItbyq7fwDm6DRCrZN0cOxEL2wHoe
         Pq8KSbQyrbDcIz+EP6UHY4R6Yp+z+KIFJ3n9YH624NHgQ/cH+jPk0FTwCgdVZgS+K4
         DrMT0njz10faxAl1TJbxUMpOdsWPQMAGKp/XxpxGRigcidC0222FYZPkESndHKywln
         QzPVp4UtuhQNrzGWmtnH2PIJaQTxInxuN4GHbve1/Mpbb1VpWaYFGUlzw7IIoiMOml
         EUser7o/Fa7Ug==
Date:   Wed, 20 Jan 2021 05:43:52 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc:     David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <jmorris@namei.org>,
        =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Serge E . Hallyn" <serge@hallyn.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Ben Boeckel <mathstuf@gmail.com>
Subject: Re: [PATCH v3 02/10] certs: Fix blacklisted hexadecimal hash string
 check
Message-ID: <YAem+DjBR92WG+bK@kernel.org>
References: <20210114151909.2344974-1-mic@digikod.net>
 <20210114151909.2344974-3-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210114151909.2344974-3-mic@digikod.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 14, 2021 at 04:19:01PM +0100, Mickaël Salaün wrote:
> From: Mickaël Salaün <mic@linux.microsoft.com>
> 
> When looking for a blacklisted hash, bin2hex() is used to transform a
> binary hash to an ascii (lowercase) hexadecimal string.  This string is
> then search for in the description of the keys from the blacklist
> keyring.  When adding a key to the blacklist keyring,
> blacklist_vet_description() checks the hash prefix and the hexadecimal
> string, but not that this string is lowercase.  It is then valid to set
> hashes with uppercase hexadecimal, which will be silently ignored by the
> kernel.
> 
> Add an additional check to blacklist_vet_description() to check that
> hexadecimal strings are in lowercase.
> 
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Ben Boeckel <mathstuf@gmail.com>
> ---
> 
> Changes since v2:
> * Cherry-pick v1 patch from
>   https://lore.kernel.org/lkml/2659836.1607940186@warthog.procyon.org.uk/
>   to rebase on v5.11-rc3.
> * Rearrange Cc order.
> ---
>  certs/blacklist.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/certs/blacklist.c b/certs/blacklist.c
> index 2719fb2fbc1c..a888b934a1cd 100644
> --- a/certs/blacklist.c
> +++ b/certs/blacklist.c
> @@ -37,7 +37,7 @@ static int blacklist_vet_description(const char *desc)
>  found_colon:
>  	desc++;
>  	for (; *desc; desc++) {
> -		if (!isxdigit(*desc))
> +		if (!isxdigit(*desc) || isupper(*desc))
>  			return -EINVAL;
>  		n++;
>  	}
> -- 
> 2.30.0
> 

Shouldn't this rather convert the upper case to lower case? I don't like
the ABI break that this causes.

/Jarkko
