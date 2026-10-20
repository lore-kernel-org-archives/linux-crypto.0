Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792505909;
	b=NobpHj06PsNYhA1xCPpFBOAnILOSytAEe9Z/RX+OFzaVopad0bStNzcxcO5wojlHsBl4
	 /8vp/H8b9QBI7zjFlgxdKAFUaQgvpNCAvFAi9vUqyHJxYOAqr0HZHXam6Fbs6BGPKUY7c
	 CCjKVeUD5w8l00c5C5/fJw9ekfEV8YTXysqSSgCKlFYWocnvlaMV5sLYY3a8jhsn0yGa6
	 bZoEroH5fzqK7k2PY07YHFhntOGv7iJpFioIqRhpSCTTihHnG1aJpPEwesWIjqShGLKCo
	 T5wiDHT8GNQfecGQ6IFLk3XXswLhNGIvepk+hxxH2JdRAzavWBgpCwfspWhVUmUy7Mg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792505909;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=qZWHzH3NnPm+6fZ0ej6D+04oG74OayCVfZeDBxBBOhI=;
	b=DrrNvjoJziKCwi7d986aQTQvUfhmEmG86/lYv09Ol7Kdw20EH/wexgNpfhol027MVhjS
	 A2V2XdZH5Wh6bN4RCm26pBBbwmpZOWGEHpeZ9N3+HhhEO7XAvCGEukNQf7GzDdBvZI0OA
	 q2eK+mQ4knmOrHjFkVbljSAUdpfYjjlQj6JwkYf8wwNmI6PPZz+7J3MxmX9Yb3vZkMA/6
	 9t39jYtPS6fXp4BRQ2011Chss+R6G8EUdH3H1XhpgyipLqgMi5ZD3Ql1JXdl0oQmsJp6q
	 Zi+bVRNhgrTCYMkmLTPdkszTitJ2DSoelqmdQxiqcGYKHZTxUvB2hgsuvLIcvat7RRQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=K76fK9aQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.181
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944AC606A31C
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 14:18:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 944AC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=K76fK9aQ
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3ab4354db11so13497571fa.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 07:18:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792505907; cv=none;
        d=google.com; s=arc-20260327;
        b=gXx2oKRuYmDxwCBukOps1XLVQQ6DUyA2OHMvpjyP6KWARPnUc7dbdd9dLPPMIO7QKR
         vYX+JlaMPzEDW3Q/6dYM53GNBwq1iBlEVgXeciGxexV5Psikp0JMfoctoy0yIaEgglQm
         wdU//7P9Kvkg5NBLk+/sjDoDKOKpkoAM6mn2ukNIzvf54KIoPmMukzNVKXf364X5gRF6
         bcnD2BsoAcXE5aq7MgA5vG/ICtWuOcVstv/GTWmzBuL4bwxLagk8TmIRdwEXMwMXlJPE
         acyLBy62BF9n/mFs9nFtrTBOjnMhoBRC++fcj+MkCaF4rf6tDFQ7MNsUb6UXqh6UTsHE
         eXwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qZWHzH3NnPm+6fZ0ej6D+04oG74OayCVfZeDBxBBOhI=;
        fh=3ZrAVPlvv3kNlXmXHjkpVspQWnzT2+0ey5bOOdN3Vzo=;
        b=M1iKzP+ayorwKTzg+nihXDgnNMIUtZGbMZ4F9p0nLjPNRv6aOCeYP8jtfhAqd4ekWL
         cJ+vXBi5VfsQs0uLjeIH6Gzk/2NN4j/ayKXtg55XqXD7ENnqVRUNXz5kga2CurWcpUI0
         yRnjKA+R/Zw39mDM6M4m+38gJ1NoZwxw4zudLAPAz/0os96GvEoIpxUyNvW2crPUTHh4
         QAaEU3WWBoOmEL9rJcRSg8RxPz6VtzFT5pDBFyAzI8kIibsFIlKxW7SSY//4HASEKx8d
         FsNyJ0S7hz6riZKniLMHBa6UivkW8CgVNqptKQDaf2Pu18Q0yAG2XSs1+IFUQcnVikJj
         C8cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792505907; x=1793110707; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qZWHzH3NnPm+6fZ0ej6D+04oG74OayCVfZeDBxBBOhI=;
        b=K76fK9aQ2yZh/bg+z4R+HxnBnzycHF3ePrQlbafqp5IpPWxrtAWpMS/+IYJVoDzNa0
         AzN7UmwFJutZy8cebCc1lyZJ7jdotTKmELyGbI7vIT4XRw2oolQHQ3kJIq0Mpl38pvLT
         dopAgFZlQOAFHQTx06vD4fXxv+nbIDs8Hv75fqT5LoLN0L9Gy+SktDG0TIvd1cgJDsaV
         oFQ+Nnftq3hLhTQav7fkwy/qtM/MX3mQLH+6d+O/xOfk04qZP3Xj8FNM2C0hdoZc2ITn
         gmdfX1r2L+UQo8tDYhuC584DG+ILI4nnvFg+ci3lsOC7eWFPUtisk46H0NrxMH08d8aH
         o8qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792505907; x=1793110707;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qZWHzH3NnPm+6fZ0ej6D+04oG74OayCVfZeDBxBBOhI=;
        b=tdXW3CqbMXx3qO9ypoN782B3v0+lej3B+aPfewngEVY0pkgI90tcli3yuAKSzUZhny
         tCxd4AIyj9FHZJjloURnDniBYEwSSvsW0H5AKnYoN+5v21o/xmYtnPo3lL2PD6ZAHrkZ
         jH1Zrsp+/+BChPEEq4Pg3yue8581Xl/NhTbuJV+dNNIVh64gMsFuYEaKNOsiVgyp/rnt
         1rTcoiO+JMEKo/sSxk5GZRBqGVoemk8FFnBxxTAD8M4iM/mzSqn52HaCTbK6Z1D5Pz3m
         FC8yCrd1dDnA9YYGSg+rQ9MK6a1Jz6FG/S+/9p7qSSZtw54FQSuhhUYIZD6Gbk+06xYm
         LmyQ==
X-Forwarded-Encrypted: i=1; AKwUvByE8CO4unsO16iM3uo4khFkwJ+fylZYCuEhplUzwYwu8qsaXd6dpfsyfU1U8O0U5qeueu0pqwmZ//5MpUw=@vger.kernel.org
X-Gm-Message-State: AFq9FYIWynT5jisdb6tRrkCOXJohwkXY9IdusIDYplHmQqRK+quvo21v
	8lfcnUTgF7juqoLgWmcD8qrs1RZ6L+oO0ymAfffeROBRF87Y5utDnTBUCaMl+Vh0FExfHsybYjJ
	0wj/fbO7Llj2XimIHSNTNEGvP3eQbbSI=
X-Gm-Gg: AYBFou1tgqtM92oKa5ISd3bTnsC9phb5ZBUWySm2VZsmuBf++onMf0fKadUhcBfk/gc
	RqImzZsHAbQPatDJZ7fWJiDZV1Zr7FIluwRpH7G5P47CbTUig01QqpnpNO5mjxSnXmyvL22eVA2
	NPIhfzaRtPw81tL1trQS5vllMH//uz/UsgjjoGyXzW7saLeWRtQDVNG5Cr6L7bDr4wR937AyaUB
	KVEaFmwA4p1uwBe+hgcogAEkv+Yj2UnLomP0gHjuwC5CsTjYMTUAZA6XsFlf6MpaxLhVh7hBUUc
	B9L4QbAHyPQZALGrmpiG+7EIpyzcaD2TLUiNs/rWGiZwTxPctGV6fBbPmbhpMP5gFgPryCNIMwf
	E6aGjV6sZA5mXdqcM9On8+mebJ56pdpwJjeZa7vcGlJDB
X-Received: by 2002:a05:651c:1502:b0:3ab:fecf:51f5 with SMTP id
 38308e7fff4ca-3abfecf5453mr2731441fa.14.1792505906296; Tue, 20 Oct 2026
 07:18:26 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAOMZO5DgENq8RU6s2CPnKsf53i=7zoBeO38m_BtV=w54hr2hgQ@mail.gmail.com>
 <VI0PR04MB122628C9AF157A9732C27068795F72@VI0PR04MB12262.eurprd04.prod.outlook.com>
In-Reply-To: <VI0PR04MB122628C9AF157A9732C27068795F72@VI0PR04MB12262.eurprd04.prod.outlook.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 20 Oct 2026 11:18:14 -0300
X-Gm-Features: AclHuK8hpD2Os0ESDXX9mxH4L7Jl1YEgykxYhPw0QzWjgIEF_lqhSiFkxHww6Ws
Message-ID: <CAOMZO5D595NYX04sw=gkKSy0Chx4d6Rn9YB4SvJtcyUCGvU_ig@mail.gmail.com>
Subject: Re: [EXT] i.MX95: EdgeLock Enclave secure storage
To: Pankaj Gupta <pankaj.gupta@nxp.com>
Cc: Schrempf Frieder <frieder.schrempf@kontron.de>, 
	"moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <linux-arm-kernel@lists.infradead.org>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Peng Fan <peng.fan@nxp.com>, 
	Stefano Babic <sbabic@nabladev.com>, Frank Li <frank.li@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pankaj,

On Tue, Jun 30, 2026 at 9:06=E2=80=AFAM Pankaj Gupta <pankaj.gupta@nxp.com>=
 wrote:

> > - An ELE-backed trusted-key provider for the Linux trusted key framewor=
k.
> Work in this area is currently ongoing. The intention is to provide an EL=
E-backed trusted key implementation that can integrate with the Linux trust=
ed key framework.
>
> > - Integration allowing Linux to use ELE as a key-sealing/ unsealing bac=
kend.
> Support for using ELE as a backend for key sealing and unsealing is also =
under development and is planned to build on top of the trusted key support=
.

> > Are you aware of any ongoing upstream or planned development activities=
 in
> > these areas, particularly for i.MX95?
>
> The activities mentioned above are the primary ongoing efforts related to=
 secure storage and key management on i.MX95.
> As these developments progress, they will be proposed and discussed throu=
gh the relevant upstream mailing lists.

Do you know if there has been any progress on secure storage and key
management on i.MX95?

If so, could you point me to existing patches or git repos with this
work-in-progress material so I can test it?

Thanks,

Fabio Estevam
