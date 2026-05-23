Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA50395D98
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 12:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779539047; cv=none; b=fNs6AwgQMyDRfrbTD1GoMzsZwWbdmnKrtW+lj0juKJN7rWg9ue8SyHHVY/+b3wSSn7X0vkHmOC2c5qX0PSowD/bIcKfzzBK/0s1If/ngfLFOFzmZqR+ofCJ+9rRhWMCHq+ToNCVX3o6LanG0tNx1Ei+8t2fZeny3lyd8kHNOzAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779539047; c=relaxed/simple;
	bh=8rJY2Ypo57R1HTvGgB8L4jUKXcQhCUj/+EHwQuN+KV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lgqPARq0O90scXG9LuGqXTt0LWrclGffoaACCyUWr2iUg9zZ9U/QTWmyFYxIVlr01Rn5wV+f6QoDFdCZOAyWz9dcqyWcjxLaYbRt8AhAVdN9AZL5v6TAiMa21N5tyXDI41OYzTDIE1eNMMogJAluktJfFJHW6qD1Y92VvLA/Hhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o74NdlAO; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o74NdlAO"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36931e4f5e8so7402339a91.2
        for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 05:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779539045; x=1780143845; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BUftknpjAzJRHNFFrDtQsWg7bJX0Pe38bqsMwsZfQGk=;
        b=o74NdlAOj3ICbxFo4EkbTJq2LrnAthPzBqOHmIW0z3gIdN7nRnYN4mOMPttEmGjl9a
         SUQnbYqNoul5Qy0sYZE+QEFITIXO6EKjb6YiwINqJnkZmUuKna7dDw9aG3ZLop0667Je
         VBgeqFBTFibjFadTOcgU7RCkT45qowHFtHtYsoDrDtLK9nzxsg3YIt1LtHWsDkr9gLaZ
         5fgDqzCusqT6GXm+ZQ7vKi8qs1jEk20eMGzULgwREunOpecmeIzulgujkgzfHlOL3bGR
         LeEn3VsjMKpmIBc1jKlDm5727vWTEEKrscKH19pNw/S/GASyRyj+4IVWuiNqB1oHjzeU
         PRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779539045; x=1780143845;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BUftknpjAzJRHNFFrDtQsWg7bJX0Pe38bqsMwsZfQGk=;
        b=LtLV4WtlgMz2MfqKJwGy7l7AfIU+XR4iTZxfZjsOtj+PfXSWhUFXFkvog43v0YkyWU
         XdIljYmPlf7Wtr7dJxbHB/4KU87d3TRj7Gt73TCEhTNwXzWjflLMomAsYvDEFxpNEFzy
         7zd9BQ2NWeP6rX0f0rB1ucu15oM+0R2GOJt4peqizue3ahu1cZVi+YD8VvaJ8zlR3K2R
         mO2ZWBq+Gxh38J3CSf4YJ2gPZECXwKRB8c61453yzYBASeBAuG8C1c6mbo/vhVv8N0sz
         p1+zKzwb0vLY1PPJeRZdI2ntYM9lo1ZZOOeEEAkqPQ45ROODrCtLY0WSuUV+dCTiqD5v
         sHkQ==
X-Forwarded-Encrypted: i=1; AFNElJ/obbgl1UrVskCovL1NRvmDhqrMR85N31mFwEn20KtXs0XrXRM3jK6JCAGMFch4ot12eV7qAZol4OE+i24=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjDhtqTmCECDWNHRJ2ZLAnpJCTHlkMyZGcuakJvb7dlKyr8giF
	FZQOFDCLvhg6IcxN6VQoIRsTCoBPZa7zi6eFeMD+J8Xf6dq4WVRdfTuk
X-Gm-Gg: Acq92OH8KSe6mIPzx6Nl+/Iq/QO/LbOFF8oOfiDcGQ29su/JitvRFVGQ4oPAKpZ2YN5
	jo0ob/4lOqMVYJRI8pwKdsdcP7YaNQ8ShmIYbyQASZ6FVRR/d7XoZd9nxBjgcF0bhUeUq12//mZ
	c/pGdvEivKVk4bAa1w/TFlmXzt19W8yL1l7UX4YHp/V+MIL8Mgpb6ffK+pSL9u9uR7UOngTIhs3
	oQmKPBcDFY4XE6B8WWgBpLkZPT9TytacQ+f4yrK1J/nuDnG62nCI9GlN+Q73uJ+rrhc4n6WrO7o
	qY22pdGXESo2KErcnH48P/1OjE+GtlNruqmd+7uyv1LETvXfD0rcdDGaa1DTeL8WhxqlPOoX6hl
	qp+9MOdmeQI8TlwbNfJPT911Bcqnt6EFlegOH2WOKfFwnjOfp+gY6ZP/Iypmm1aga8dR8aSBcUb
	uDXnr01Tdcs1g/w9Kp9OepoahfhxjG2Vxmug==
X-Received: by 2002:a17:903:440f:b0:2b0:67a7:5c4b with SMTP id d9443c01a7336-2beb0603fbemr81368385ad.28.1779539044856;
        Sat, 23 May 2026 05:24:04 -0700 (PDT)
Received: from [192.168.89.2] ([125.149.177.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58b2ebcsm45002225ad.49.2026.05.23.05.24.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2026 05:24:03 -0700 (PDT)
Message-ID: <5315a2f6-3504-4660-8a64-51f7f6b69a45@gmail.com>
Date: Sat, 23 May 2026 21:24:00 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Add packet-mode ESP offload for Airoha/EIP93
To: Christian Marangi <ansuelsmth@gmail.com>,
 Antoine Tenart <atenart@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 netdev@vger.kernel.org
References: <20260523121522.3023992-1-hurryman2212@gmail.com>
Content-Language: en-US
From: Jihong Min <hurryman2212@gmail.com>
In-Reply-To: <20260523121522.3023992-1-hurryman2212@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 21:15, Jihong Min wrote:
> This series adds the missing plumbing for ESP offload engines that
> operate on whole ESP packets instead of only exposing AES/HMAC through
> the crypto API AEAD interface.
> 
> The normal ESP software path can already call into accelerated AEAD
> algorithms, but packet-mode engines such as EIP93 can also generate and
> consume ESP packet framing: padding, pad length, next header and ICV.
> That needs a slightly different XFRM offload contract so the netdev
> driver can hand the skb to a packet backend rather than trying to make
> hardware fit the software trailer layout.
> 
> Patch 1 extends the ESP offload infrastructure for packet engines while
> preserving the existing behavior for drivers that do not opt in.
> Patch 2 exposes an EIP93 ESP packet backend for encapsulation and
> decapsulation.
> Patch 3 wires Airoha Ethernet GDM netdevs and DSA user ports to that
> backend through xfrmdev_ops. ESP GSO and ESP TX checksum offload remain
> disabled.
> 
> Runtime testing was done on a Gemtek W1700K2 running OpenWrt with the
> same changes applied on top of a 6.18.31-based kernel.
> 
> Test parameters:
> 
>   - Static IPv4 transport-mode XFRM SAs between the AP and host.
>   - ESP transform: auth hmac(sha1), enc cbc(aes) with a 128-bit AES key.
>   - iperf3 TCP test, AP as client and host as server:
>         iperf3 -c <host_ip> -P 4 -t 10
>   - The host always used normal Linux XFRM software processing.
>   - With AP ESP offload disabled, the AP also used the Linux XFRM
>     software path; in this setup, EIP93-backed AEAD crypto was still
>     available to that path.
> 
> Network-relevant test setup:
> 
>   - AP: Gemtek W1700K2, Airoha AN7581/EN7581, 4x Arm Cortex-A53 at
>     1.4 GHz, 2 GiB RAM, airoha_eth wan (GDM2) netdev, 10Gb/s full-duplex,
>     MTU 9200, EIP93 crypto and IPsec packet engine present.
>   - Host: AMD Ryzen 9 9950X3D, 16 cores/32 threads, Open vSwitch,
>     MTU 9978, backed by a ConnectX-6 Dx 10Gb/s full-duplex link.
> 
> AP to host iperf3 result:
> 
>   AP offload      Sender          Receiver        Retransmits
>   on              918.2 Mbit/s    913.6 Mbit/s    0
>   off             782.4 Mbit/s    778.6 Mbit/s    3569
> 
> This is a 17.3% receiver-side throughput improvement for the AP TX ESP
> path in this setup, with retransmits eliminated in the offloaded run.
> 
> Jihong Min (3):
>   xfrm: extend ESP offload infrastructure for packet engines
>   crypto: inside-secure: add EIP93 ESP packet backend
>   net: airoha: add EIP93-backed ESP XFRM offload
> 
>  MAINTAINERS                                   |    1 +
>  drivers/crypto/inside-secure/eip93/Kconfig    |   10 +
>  drivers/crypto/inside-secure/eip93/Makefile   |    1 +
>  .../crypto/inside-secure/eip93/eip93-ipsec.c  | 1413 ++++++++++++++++
>  .../crypto/inside-secure/eip93/eip93-main.c   |   69 +-
>  .../crypto/inside-secure/eip93/eip93-main.h   |   38 +-
>  drivers/net/ethernet/airoha/Kconfig           |   11 +
>  drivers/net/ethernet/airoha/Makefile          |    1 +
>  drivers/net/ethernet/airoha/airoha_eth.c      |   51 +-
>  drivers/net/ethernet/airoha/airoha_eth.h      |   69 +
>  drivers/net/ethernet/airoha/airoha_xfrm.c     | 1474 +++++++++++++++++
>  include/crypto/eip93-ipsec.h                  |  132 ++
>  include/linux/netdevice.h                     |    3 +
>  include/net/xfrm.h                            |    8 +-
>  net/ipv4/esp4.c                               |    6 +-
>  net/ipv4/esp4_offload.c                       |   29 +-
>  net/ipv6/esp6.c                               |    6 +-
>  net/ipv6/esp6_offload.c                       |   29 +-
>  18 files changed, 3324 insertions(+), 27 deletions(-)
>  create mode 100644 drivers/crypto/inside-secure/eip93/eip93-ipsec.c
>  create mode 100644 drivers/net/ethernet/airoha/airoha_xfrm.c
>  create mode 100644 include/crypto/eip93-ipsec.h
> 

One note I should have included in the cover letter:

The hardware behavior used by this series was studied from the out-of-tree
IPsec branch of the mtk-eip93 driver:

  https://github.com/vschagen/mtk-eip93/tree/ipsec

That code was useful for understanding the EIP93 packet-mode ESP descriptor
programming and SA record values.

This series is not a direct import of that driver. The implementation was
rewritten around the current upstream driver layout and the Linux XFRM
netdev offload model, with EIP93 exposed as a packet-mode ESP backend used
by the Airoha netdev driver.


Sincerely,
Jihong Min
