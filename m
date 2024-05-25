Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64A92904;
	Sat, 25 May 2024 00:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716595726; cv=none; b=Xo6PyeOB/86Ty83hde7AXQ0uCk07j/wTeiC5MwA72EVTWGDdr6eq0PIejDQfmzmVhGude+dOmtsk25sGijX66hTmi1a8IHpFIM6kGFCckgmVsiMA0lqF8TLH2bFzQl1LRNjCGmJjYMcC4n5a3G7zt7Ew6k7e80948D19/MHcJkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716595726; c=relaxed/simple;
	bh=rD1Td5m/uOxePNcfw/EcXtgcV4e2A5Lctgq18zEiOGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/wbDEskg9NYgIN+npmOGWNS4e+f+aM7oA0d0qO1Wvr+MS8nSsKlJzGc+vipesbc/+3Ys1hXrnYmyBM6NB8efQRSimwgfh/xGhoD7dx50LjYycwW129wCqdD+9kMHQtqdsZ/6jOwhkxgm/4/wAEojuF8T2aiFGxRb/8UaqtuMOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Sd4JEoDB; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Sd4JEoDB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=hGKYxsadqMnIssMbMYEx0iVDsK7aQlY3c7mbcRJzx2c=; b=Sd4JEoDBf+gLqn+R
	vmJ+Yrimbtiie3lUnBXYabJ/2ShgeehHqWMogKTezPnFrfbmOzAuoU0buroVNTxJIccK2Ifyr5QRc
	izmLgOHD6TTmaRTEe9YWdbUPjjkgEcioLM+kNyG9x4U/2ni2P75xcVUWTMc0ALxoElF6XZ2wFo2uo
	5CME6p2k/x/L5P5kHXO+9yvCWHfhp7uo1tKumxWfpBYl+b4hFlZCSUow9w1lztu0mJ7xCDt2R+akA
	mVDKvGhHkpg4tfpu/wJyCH9Q+ee6rkNiM5AUe06kEhb+jHzgatrE1+YnPR5E1FNqiXR2zw+n8tqNO
	4+vpt7g/1qXBVBEFZg==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1sAexk-002TRF-1a;
	Sat, 25 May 2024 00:08:40 +0000
Date: Sat, 25 May 2024 00:08:40 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hifn_795x: Remove unused hifn_*_command structs
Message-ID: <ZlEsCJyWmIzlby4w@gallifrey>
References: <20240511145426.226379-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20240511145426.226379-1-linux@treblig.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 00:08:27 up 16 days, 11:22,  1 user,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* linux@treblig.org (linux@treblig.org) wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> Remove 'hifn_mac_command' and 'hifn_comp_command' which are unused.
> They're the same structure as 'hifn_crypt_command' which is used.
> 
> (I was tempted to remove
>    hifn_base_result
>    hifn_comp_result
>    hifn_mac_result and
>    hifn_crypt_result
> which are also unused, but they vary, and perhaps they're telling
> someone in the future what to look at.)
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Ping.

> ---
>  drivers/crypto/hifn_795x.c | 17 -----------------
>  1 file changed, 17 deletions(-)
> 
> diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> index b4a4ec35bce05..9259915267454 100644
> --- a/drivers/crypto/hifn_795x.c
> +++ b/drivers/crypto/hifn_795x.c
> @@ -495,16 +495,6 @@ struct hifn_crypt_command {
>  #define	HIFN_CRYPT_CMD_SRCLEN_M		0xc000
>  #define	HIFN_CRYPT_CMD_SRCLEN_S		14
>  
> -/*
> - * Structure to help build up the command data structure.
> - */
> -struct hifn_mac_command {
> -	volatile __le16	masks;
> -	volatile __le16	header_skip;
> -	volatile __le16	source_count;
> -	volatile __le16	reserved;
> -};
> -
>  #define	HIFN_MAC_CMD_ALG_MASK		0x0001
>  #define	HIFN_MAC_CMD_ALG_SHA1		0x0000
>  #define	HIFN_MAC_CMD_ALG_MD5		0x0001
> @@ -526,13 +516,6 @@ struct hifn_mac_command {
>  #define	HIFN_MAC_CMD_POS_IPSEC		0x0200
>  #define	HIFN_MAC_CMD_NEW_KEY		0x0800
>  
> -struct hifn_comp_command {
> -	volatile __le16		masks;
> -	volatile __le16		header_skip;
> -	volatile __le16		source_count;
> -	volatile __le16		reserved;
> -};
> -
>  #define	HIFN_COMP_CMD_SRCLEN_M		0xc000
>  #define	HIFN_COMP_CMD_SRCLEN_S		14
>  #define	HIFN_COMP_CMD_ONE		0x0100	/* must be one */
> -- 
> 2.45.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
