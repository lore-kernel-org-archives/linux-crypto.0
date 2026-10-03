Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAAA2F260C;
	Sat,  3 Oct 2026 21:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791062510; cv=none; b=aTEIWWf3YvGyMJQHXXUrRocrfM/jME3EZH0lr2kqtFkvEOizWL1W9A50PWUazQbO7P8VKNpSMg10auCaewNQ1PaHZCsXOsFoGJHOUjoGJA2jL90hDGPB5G+l5XKqv5QhMeZF4fzZhYKg9dc7gHhMao56Lp7Wq3kuGH2xOR9TKJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791062510; c=relaxed/simple;
	bh=Cj+jJtKzKTj4QUIJmxOK+pHBvigpBLU3uvq91tlzTvw=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=iBpTNlVf8WXySvsl/FXc7OLOpImn0FUcXzTmKRaL6GpXaHUulQ0zrj/I0dv611JDXXB+Ds9FmbzFe9lNjmcgMUJZZhUfoTMI3U0h6Ngo43VpoYwr4rj+vqwBVEBoJlKCaR7Ql/QCt/RyM1IiY2np6XFws/lYAqIR2OCFEFrie5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=VqH80xQw; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="VqH80xQw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=w0vFGAQrTlZQVOAGyxoUEUpagoLajH3K19LKdT8aOkk=; b=VqH80xQweQBuB5Lu437obUxkBS
	7Bc+X71VP//gM8Jecmgwr8vsraRopIsULHDh8PX+pZydQYKuA4J/sSDk7EqmRrTAbC3SmEa84iVoJ
	6syB/KjiouvOgDICeu3TwkB4sY81+vhTxmVDk9dhJQDu64s+2EV6XUOa4DvecmlNY4qOhZm21toUb
	O46akZdY2q5RqMyaV1eR+dgVxCwfSx7NBYAI6uB39TpAWMXGwnrwqwJ4Rhx9d+Ik/gIxUlrJkeE1G
	8K3ORZ8UU+FBclytT1Q5vcYj1BrpP8cXbjavixq/8+fgeSIzej7t+OjYT+7upfmtS54WnrviZfSfn
	Y8H0YbBg==;
Received: from [::1] (port=55232 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.100.1)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1xD7B1-0000000H2IA-2Wgo;
	Sat, 03 Oct 2026 23:21:47 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 03 Oct 2026 23:21:44 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
 davem@davemloft.net, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - reject overlong RSA CRT parameters
In-Reply-To: <ao4xobfWhs5Ss8Uy@gondor.apana.org.au>
References: <20260810154024.3178145-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <ao4xobfWhs5Ss8Uy@gondor.apana.org.au>
User-Agent: Roundcube Webmail/1.6.19
Message-ID: <752d9ff313bb52a7f8d2295161c1d9a4@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On 2026-08-26 02:21, Herbert Xu wrote:
> On Mon, Aug 10, 2026 at 03:40:24PM +0000, Jérémy Jean wrote:
>> caam_read_rsa_crt() right-aligns dP, dQ, and qInv in buffers sized
>> from the corresponding prime. rsa_parse_priv_key() only bounds these
>> integers against n, so a malformed key can provide, for example, a
>> two-byte dP with a one-byte p. dstlen - nbytes then underflows and
>> memcpy() writes outside the allocation during set_priv_key(). KASAN
>> reports a slab-out-of-bounds write in caam_read_rsa_crt().
>> 
>> Reject empty or overlong CRT parameters after stripping leading zeros.
>> qInv is consumed by CAAM as a p-sized value, so size it from p rather
>> than q to match the DMA mapping in set_rsa_priv_f3_pdb(). Let the
>> top-level key cleanup handle partial form-3 allocations and return the
>> specific error to the caller.
>> 
>> Also test nbytes before dereferencing it while stripping zeros, so an
>> all-zero integer does not read one byte beyond its input.
>> 
>> Fixes: 4a651b122adb ("crypto: caam - add support for RSA key form 3")
>> Cc: stable@vger.kernel.org
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>> ---
>>  drivers/crypto/caam/caampkc.c | 69 
>> +++++++++++++++--------------------
>>  1 file changed, 30 insertions(+), 39 deletions(-)
> 
> Is this driver still maintained? If not let's just remove it.
> 
> Thanks,

Hello,

I don't know for sure, but it is still getting fixed, e.g.,
https://lore.kernel.org/all/FF2F0DC4D3930E6A+20260923101457.204629-1-zhaojinming@uniontech.com/

Regards,
Jérémy
