Received: from mail-m16.yeah.net (mail-m16.yeah.net [220.197.32.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D750232B98A;
	Mon, 17 Nov 2025 10:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763374123; cv=none; b=bnzHc/nbZ1ys34CXDOT32kfxYSUQciXBVqIbkiQtClFlc6LsDT9x5U1YgPu8XkhQdBCNWhEnVoR8VDhPuNyULVBRplVWldkeSRS6VGZxd3t6MhaIxRusqAboZyd6CH1NF7zyX32Wyn1oDe+tTv0VZ1JeIsbuy66ul0FREC4+KNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763374123; c=relaxed/simple;
	bh=HbCz8YLG9Amwgm/orq88CmskYMtURJk6OPTehqK7koA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=maBPskKgBouHDuSoA/MwXoRbk+yZ7lbf1uQgOmbhw5r26GZe3WKq9nb4IPh5CIDYv4yoTXBxppBAeqFLaZlk3qBuG+U+lpda9NTRhrP2T+K/y0T50FSk/8uWcYyujx9+1jgC+GCnx6UWXQu16fERourRz0AqBGf8YTl1zZH3D0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net; spf=pass smtp.mailfrom=yeah.net; dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b=YJVjz7pR; arc=none smtp.client-ip=220.197.32.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yeah.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b="YJVjz7pR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yeah.net;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=ZGoM8BR5/8+LO/jGHnNF3hsgKqe4bKMupg4l6A1D9XU=;
	b=YJVjz7pRT6kHf5fghNEgQfz35nJVmzRbXbjD7HAfR6WRTKE5V8m7254bXj7L6+
	y2Ru5DsE+rT6BiXIWpWhdiYHxFMnuM0nQbJfi5pAwgGEIKKcuZ5aei7HMAIPxrAi
	DL3e/h1qLNtKjLIhixkyyEmWsB5CaPZkTJBzRZddJ6fSU=
Received: from [192.168.31.127] (unknown [])
	by gzsmtp1 (Coremail) with SMTP id Mc8vCgDn+t0L9Bpp97dKAQ--.21938S2;
	Mon, 17 Nov 2025 18:08:13 +0800 (CST)
Message-ID: <c829e264-1cd0-4307-ac62-b75515ad3027@yeah.net>
Date: Mon, 17 Nov 2025 18:08:07 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: padlock-sha - Disable broken driver
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>, Eric Biggers
 <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 CobeChen@zhaoxin.com, GeorgeXue@zhaoxin.com, HansHu@zhaoxin.com,
 LeoLiu-oc@zhaoxin.com, TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com
References: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
 <20251116183926.3969-1-ebiggers@kernel.org>
 <c24d0582-ae94-4dfb-ae6f-6baafa7fe689@zhaoxin.com>
Content-Language: en-US
From: larryw3i <larryw3i@yeah.net>
In-Reply-To: <c24d0582-ae94-4dfb-ae6f-6baafa7fe689@zhaoxin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Mc8vCgDn+t0L9Bpp97dKAQ--.21938S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrJF1fuFyrWrWftFyxAF43ZFb_yoWxXrg_ur
	yDXrWxWas8C3yIqF1YgFsrKF13Kw47Wr1kGay8Ja13W34jqFs8tFnFgFn29rWxZayfXrnr
	Jry0vw1a9ryFkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8qsj5UUUUU==
X-CM-SenderInfo: xodu25vztlq5hhdkh0dhw/1tbiNg4hXWka9A6+dgAA3F


On 11/17/25 17:03, AlanSong-oc wrote:
> I will submit the finalized patch immediately. 
Dear AlanSong-oc,

I also want to nag a few more words. I think after a period of time, 
most of your machines without external graphics cards may not be able to 
install Debian properly (I don't know if KX-7000 is the same). It seems 
that GNOME 49 no longer uses X11 by default but Wayland. However, as far 
as I know, Wayland requires a graphics card driver to work. I have over 
ten laptops with your CPUs built-in here. The operating system I 
installed is Debian testing, but now GNOME is not working and I have to 
use XFCE4.  😭

Regards,

larryw3i

