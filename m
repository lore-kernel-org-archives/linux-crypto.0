Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65833CC9FE
	for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2026 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775835134; cv=pass; b=NvtvQo0dKjsBYfdEi89cqiiGliA3ZkwwlZl1E0sWJNRjv9PWDTDd2Ot6vHPGh4qMHkRcfJvo9t1zIBOEFMIBWh5ch4qdDk+/nemBINDclZwNHbVeYNBpy2mRYrtl83zo0yJOslwaDguWdL3KjIjTM4Y+zyo/Ge0C1B/2TvqQmx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775835134; c=relaxed/simple;
	bh=OBQJPBhzAm5teFuL1it4zrQEsej5woZw67yMwyO4d8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hfousxzQ1tTsDm853eZKZJTNjoqg0ROqdi1J493WxRwXVQBIsM9JFkJMOMgLx8V/eFa3PPHYR26QugmvzBJ3hHxX9rF3gfv7mTaHGePeUa5r2jIUuAyU8NDlF6fk+O8KhzYBBoqfRtGmh3H6PaxngA7pmvg5E5tXIv67ZNfjMeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x0f.com; spf=pass smtp.mailfrom=0x0f.com; dkim=pass (1024-bit key) header.d=0x0f.com header.i=@0x0f.com header.b=cs+zJ0r8; arc=pass smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x0f.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0x0f.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0x0f.com header.i=@0x0f.com header.b="cs+zJ0r8"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1271257ae53so9590780c88.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 Apr 2026 08:32:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775835131; cv=none;
        d=google.com; s=arc-20240605;
        b=Y603doJbnawmX8gdJsYLJ6oTsRxBYSDFkHoApUzzPXOwQD+BNU1X9rkKy172SNzK8R
         FzqTMB6/JpHcxOlEr116r6WH0YOwUUy8KnCtPMgkZX+9iVzGS/ksyDSygGp8PWlXXmQY
         9J6K/NChPmvtO+/gOwyuhs0YuibdYfZjZN5EVxBTs/oxkA7WHmoNsUPNYva1Wm/CMPH0
         JmFDmIUcXRkmceXiZD8D5bAh63K/+ruJa7kzm5U6EUHG5rStA0xdRyeNnP16aIDVCJPk
         +iMyz2CzIkk7GCj539QSxnhaBLYpv/ykKPTsz6UxO6JA5x1ABzo8YkVWIKWArCrkqfZi
         P2lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OBQJPBhzAm5teFuL1it4zrQEsej5woZw67yMwyO4d8U=;
        fh=yixzBeyvH9wTyAv/Wvv+qeJURJfmBWzeI9F8IqtRuVw=;
        b=TzN7PKBlNTPwEpfqDPdCtrqytVRKicpn8q9j6mKy8HnN1Qb4nU8WLiQ1rc0AZA6SqA
         3BRVWGoHxH/eTjK9EDmGXIcj810KKpQI5gbdU/gr9TVxgIzYQx4jERekz8iDRL++L7DA
         7RCzYbLf2vxzqdAj3vaeHVHLJvWpav8xx0fjJz+HCmINHXqrVGcjlNTXOTQCbseEvDYb
         OftvRYlcC1NABTyZyNTNP60R1GJ3YTpbnFG6zlk0my/1P2wprBSdSmQK8XlVJNrzh9Zu
         XjNtTXtrigi13NoLOwheW59U0kOtGq/hNkr0GI6xHYxeAnftIirhFx74ehyeG8nqLSO/
         fzpg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google; t=1775835131; x=1776439931; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OBQJPBhzAm5teFuL1it4zrQEsej5woZw67yMwyO4d8U=;
        b=cs+zJ0r8E1VxbeERL/6orYDfRzBNN0xV+FBDuuOmam2/EuHZ7scxaUctzZ3REo2LBr
         KdQSu4tLtUeUQ/Am7PGmtjXBLQ/7knpdVClf5erC+tpkhYxe59BfVvuW88STHDIDr49T
         TpKPrBeobAalm+DfnxseCj+mCeyPg4AFXq4Ow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775835131; x=1776439931;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OBQJPBhzAm5teFuL1it4zrQEsej5woZw67yMwyO4d8U=;
        b=HfTb2o/QD7pqxRcYBQdPYKv7cxkpubYiH6f5/K6LqnZWS7a2MBOkggpqwfotFjTek+
         MxheT1KCIUf0MQBxRD0wBhrKPy5iT8fugx3ChTFU0mpBnoasBcVVZhR7iNDv8EGhuqal
         y2Ph+knjT0TjndF3GFebWug8j9i4l6DKFCV5kgqBbZta144sV/1srL5D97MlLWF3wToN
         86vwxM7RsR5Z82z0PwYoBAY7uTxIW/DoOLUtxM8PDQkmyFdJUHRVrhwMN7WH2kpPtKXz
         ZoZqn7WDPbCUWHE14gfkse5W+MQRaP45vjMF0lQQdssdt9u91lv0WsjI/38kqzOBHEBN
         Nr8w==
X-Forwarded-Encrypted: i=1; AJvYcCWTGH88Vp92VbbiISCMMnzZbp6rVQkmmKgGa5eTw99Yh1mF42y0myXTlPv3NlONyT3paqREf1GQvmwnEq8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfKZqncm+CNxS+Q7ssdKZd2pMzeeVvuyPpoyq14UKZ/B3cHtLR
	TNLwMQTZzvii4S+1Zn+PrMtuHVcH1dKn2Dl5fgRolUO33aExXK3Pm1roHy68FR64gG1C5z829pL
	cul43aG6ew4QfULbNVlzJv01iSFvXXo2HxePspZpbGA==
X-Gm-Gg: AeBDiev4XKlrhxDXr7maA+V6w+a0qj9gRZW5En+7ultevCKoPRtjhujdxkbHnaUWD25
	dWUHE6RIE8T/TOGln5TWqhbpqnwdiEHE8pVSCIMDLN7zl9xedD3qDuDeyafV7LsREYL50KDOcF8
	pNjX0ZXh9AmP289KHqGHQkZK/GHoq5LwX+IhhAqC/Syz+u4NfWe7zPh6KB7CnDa9lTCnQCCnWcz
	XsWn7K+5u/0gm+wJwa133Rz8WIDTUTHNlVRTnGEipk02a8n8DHS171TumBjjYlDK0iZxk4DDA91
	9+B3
X-Received: by 2002:a05:7022:6097:b0:128:ccb7:7fa3 with SMTP id
 a92af1059eb24-12c34f069f8mr2159203c88.34.1775835130696; Fri, 10 Apr 2026
 08:32:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120319.397219631@kernel.org>
In-Reply-To: <20260410120319.397219631@kernel.org>
From: Daniel Palmer <daniel@0x0f.com>
Date: Sat, 11 Apr 2026 00:31:59 +0900
X-Gm-Features: AQROBzAnX-XEClLFV-qWYFUzCuq4P43sNZviESiWFI1yCPXm2VtVZ2QkaUGJoPY
Message-ID: <CAFr9PXk7qK8-2JWrrfgXHoS9JWTRL+WobLjmAesyCE9VLL8ZyQ@mail.gmail.com>
Subject: Re: [patch 27/38] m68k: Select ARCH_HAS_RANDOM_ENTROPY
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-m68k@lists.linux-m68k.org, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
	Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, Dinh Nguyen <dinguyen@kernel.org>, 
	Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi

On Fri, 10 Apr 2026 at 21:39, Thomas Gleixner <tglx@kernel.org> wrote:
>
> The only remaining usage of get_cycles() is to provide
> random_get_entropy().
>
> Switch m68k over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
> providing random_get_entropy() in asm/random.h.

I have built and booted this on my Amiga 4000 and it apparently still
works so FWIW:

Tested-by: Daniel Palmer <daniel@thingy.jp>
