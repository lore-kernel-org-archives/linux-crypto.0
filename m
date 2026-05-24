Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB7633DEC2
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 21:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779657004; cv=none; b=boZW/zrZOKoP0tZwFHiDh0jlYC/ZgJQ9w86iDXdtR8X7xV/N7B4BpT19o2hP6sjevE8GiNfs6nTlmnqQwpktebb+/oo+LFhZefduvNA2sPVB9KH1ViRo3GEl+OqeA9AWBUmEAQ7hi9GmPerl2SifOqtniaqVUK8zLdl2LRO4VKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779657004; c=relaxed/simple;
	bh=Tb2Ldi9OKa2c4FpJbAVSvDyJ20G5JFc4XDg6jtza/Cw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ef2gmgKE5eAUttZYtK+lhEtY12dqlNeYrPMSWtigLcMCRHA+hKsWL8Vt+2qwD3OMsP7m/k81t+giqTSzeneiDGQQ59hOTYbIk29wrUIwDmgfzigXpSz3+jnzyJoab3+X04agl8QhJlfaZ2RiEQuSgMjM+3kszh+Y+7YVurgEe+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=bWcPg2/4; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="bWcPg2/4"
Received: (wp-smtpd smtp.wp.pl 32184 invoked from network); 24 May 2026 23:09:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1779656990; bh=i/5SUts/HsARtJThCXml0mjybiWuiq3vVlYkikbna5o=;
          h=Subject:To:Cc:From;
          b=bWcPg2/4Pt3pea2pjwd5N8qYDe/WAwXkPCMONcPQH4qisVQ01pWJGn61SIr7gWld8
           SBXU3Hcjij3SdOUBcYSDQOVJwuzYZYzGqcsfkSspftGQCVE9rHRNY6aUJk3vR9BnLD
           lktWbRa4yPfh3rPf+izcFhSOgH7PEAFfk/1tTj2hB7JxV74q74X55avY6WXI6BX3o+
           eR7OmZQi3DaFSIG8Kq94+/DX7jHfSPIOy2aUtp9IzhLcyNb9fRiNC+By/SbX5ei83p
           e29OIcMSmKBB94vQZRmwxGsL9hdy5DezuyYf7zXplAiD3Y6uolYTPGYv6N2+bxh/sX
           lo3tiWuWemQVg==
Received: from 83.24.127.64.ipv4.supernova.orange.pl (HELO [192.168.3.203]) (olek2@wp.pl@[83.24.127.64])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hurryman2212@gmail.com>; 24 May 2026 23:09:50 +0200
Message-ID: <ddb3ad67-5125-457a-b033-8804f08b4439@wp.pl>
Date: Sun, 24 May 2026 23:09:50 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] crypto: eip93: return IRQ request errors from probe
To: Jihong Min <hurryman2212@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
 Antoine Tenart <atenart@kernel.org>, "David S . Miller"
 <davem@davemloft.net>, Richard van Schagen <vschagen@icloud.com>,
 linux-kernel@vger.kernel.org, Benjamin Larsson
 <benjamin.larsson@genexis.eu>, Mieczyslaw Nalewaj <namiltd@yahoo.com>
References: <20260524194528.3666383-1-hurryman2212@gmail.com>
 <20260524194528.3666383-2-hurryman2212@gmail.com>
Content-Language: pl
From: Aleksander Jan Bajkowski <olek2@wp.pl>
In-Reply-To: <20260524194528.3666383-2-hurryman2212@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-WP-MailID: 10078de62747bcf64ebc8a71ee6a6f68
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [oQoX]                               

Hi Jihjong,
I sent same patch a few days ago. You can find it on Patchwork[1].

1. 
https://patchwork.kernel.org/project/linux-crypto/patch/20260518212506.292170-1-olek2@wp.pl/
Best regards,
Aleksander

On 24/05/2026 21:45, Jihong Min wrote:
> devm_request_threaded_irq() can fail, but eip93_crypto_probe()
> continues as if the interrupt handler was installed. Return the error
> immediately so the driver does not register algorithms for a device that
> cannot signal completions.
>
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Originally-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Jihong Min <hurryman2212@gmail.com>
> ---
>   drivers/crypto/inside-secure/eip93/eip93-main.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
> index 7dccfdeb7b11..276839e1a515 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-main.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
> @@ -433,6 +433,8 @@ static int eip93_crypto_probe(struct platform_device *pdev)
>   	ret = devm_request_threaded_irq(eip93->dev, eip93->irq, eip93_irq_handler,
>   					NULL, IRQF_ONESHOT,
>   					dev_name(eip93->dev), eip93);
> +	if (ret)
> +		return ret;
>   
>   	eip93->ring = devm_kcalloc(eip93->dev, 1, sizeof(*eip93->ring), GFP_KERNEL);
>   	if (!eip93->ring)
