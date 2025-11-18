Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC3C2F363F
	for <linux-crypto@vger.kernel.org>; Tue, 18 Nov 2025 08:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763454279; cv=none; b=kV5vp00cUU3EiW42rhKiEqBGh2pFD7sdsQWkSP9kNtiWca+cMaX0OL6z17qq8zy1uKWJlep3LM1nYXdbQu2ON8QmCNwzOa1fzH3zvKOI0GPrMm7HfvHSQ54k5VM5PhyjF1u4oYHf7uWHtaTTJ9PIPhpdkJ6jcEtn9Rhw30Jawr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763454279; c=relaxed/simple;
	bh=lTOIlzIyKMgsX3aqGJXsr0wy1f3tRqcuMjDRKEpejpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=YxOzVnrA17y3lwreFhGMO3NmGvA14dYoFk1oL9i1vhklYLsBOcRD6ddg/E2r4YLQPazd11UWWu2lWNsGgsZ3VE40+BlSRA74xpX+WIbcRVwbWiYdVGKqJavHd1ReXgVsfFK+z7TMwWfI5VBEpBr6HKQjpj+4gCankBD1X9DIH8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1763454273-1eb14e3d8899e30001-Xm9f1P
Received: from ZXSHMBX2.zhaoxin.com (ZXSHMBX2.zhaoxin.com [10.28.252.164]) by mx2.zhaoxin.com with ESMTP id q0zNv7sWKB1Co6xB (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Tue, 18 Nov 2025 16:24:33 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX2.zhaoxin.com
 (10.28.252.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Tue, 18 Nov
 2025 16:24:32 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Tue, 18 Nov 2025 16:24:32 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.164
Received: from [10.32.65.156] (10.32.65.156) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Tue, 18 Nov
 2025 16:22:37 +0800
Message-ID: <e15e6946-2de8-4f12-8665-814bb2a9e013@zhaoxin.com>
Date: Tue, 18 Nov 2025 16:22:02 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: padlock-sha - Disable broken driver
To: larryw3i <larryw3i@yeah.net>, Eric Biggers <ebiggers@kernel.org>,
	<linux-crypto@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
X-ASG-Orig-Subj: Re: [PATCH] crypto: padlock-sha - Disable broken driver
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
	<CobeChen@zhaoxin.com>, <GeorgeXue@zhaoxin.com>, <HansHu@zhaoxin.com>,
	<LeoLiu-oc@zhaoxin.com>, <TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>
References: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
 <20251116183926.3969-1-ebiggers@kernel.org>
 <c24d0582-ae94-4dfb-ae6f-6baafa7fe689@zhaoxin.com>
 <c829e264-1cd0-4307-ac62-b75515ad3027@yeah.net>
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
In-Reply-To: <c829e264-1cd0-4307-ac62-b75515ad3027@yeah.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 11/18/2025 4:24:31 PM
X-Barracuda-Connect: ZXSHMBX2.zhaoxin.com[10.28.252.164]
X-Barracuda-Start-Time: 1763454273
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 1284
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.150302
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------


On 11/17/2025 6:08 PM, larryw3i wrote:
> On 11/17/25 17:03, AlanSong-oc wrote:
>> I will submit the finalized patch immediately.
> Dear AlanSong-oc,
>=20
> I also want to nag a few more words. I think after a period of time,
> most of your machines without external graphics cards may not be able to
> install Debian properly (I don't know if KX-7000 is the same). It seems
> that GNOME 49 no longer uses X11 by default but Wayland. However, as far
> as I know, Wayland requires a graphics card driver to work. I have over
> ten laptops with your CPUs built-in here. The operating system I
> installed is Debian testing, but now GNOME is not working and I have to
> use XFCE4.  =F0=9F=98=AD

Thank you for reporting the issue on the Zhaoxin platform. However, I
would suggest not discussing the unrelated display problem in this patch
email. Regarding the display issue you encountered, as far as I know,
using Wayland for display does not require a dedicated graphics driver.
Wayland can operate using the generic SimpleDRM driver. However, I have
not checked whether SimpleDRM is enabled or available in Debian. If you
need the proper graphics driver for the Zhaoxin platform, I recommend
contacting the OEM or Zhaoxin customer support.

Best Regards
AlanSong-oc

