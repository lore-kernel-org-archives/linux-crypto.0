Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F071E25E3;
	Wed,  7 May 2025 05:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746596505; cv=none; b=P5AiEj0N7q/DTkKobb+NcX4AdHemw0W/fjHDG1fsl5w418PfPSNCrWOFuqfOh2XPoY5+jLEOfgCFNRVo4END054Tp79mloG7PhrIhoEYNoIk2z2j+T2/ASwbJHF2gveBrPCHCoU5+nbd7HkreF6KBPhcadGabZGsMv//AtOmY1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746596505; c=relaxed/simple;
	bh=LEtuTQ95S5zNWQ6ILd3h8AYtfPMOrGBJmza5TNoXkrw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pio899kAlbv38qLombI90SrSh+H67RVw9H+i8MQzyHJCjBmzFSgfJbwtmrd8t9np3Q/tgSaCOucIba9FHnjv07mBQyXH99XOcykEgZ+PRJfM3KSOjLb0rNwKtaCGt2kn3UIrzws8vQTVI5vt4PLSmZBvxr3Wgy3ejc+6FI7lDFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rdWZE5Vg; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rdWZE5Vg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=LEtuTQ95S5zNWQ6ILd3h8AYtfPMOrGBJmza5TNoXkrw=;
	t=1746596503; x=1747806103; b=rdWZE5VgPZyk1G0wHId0gvixCBs9XtmamHnIlFALlXwBg2f
	YaL4XD19WoeWLNO65jss3P+DBU7mWlGQGj/GwiG4Gwi8ODgfEQaZwhkyHjj5D786kEp5ortKAbVcv
	gYAW9cNx1ro1w6SDjHoEiAkPG1C3Cefv/YFVTyQtmfm+Md+vphCe4LacSrYBAaSfzYpHc6r+f3y06
	zIrNGKgERZtVdYG7r79ASy6/UwInjphP4Zrf0n6osC6Q88eQb4hfbD0gQlmSZd1DxqZ8Jqyp78DbQ
	2ouhdZhW469HqJxNgTK9aDCvn23P0mhHSI8uqiTfI5Mgdd17Ih9RFBS2SSLEQ57g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.1)
	(envelope-from <johannes@sipsolutions.net>)
	id 1uCXXF-00000007LGf-2K7m;
	Wed, 07 May 2025 07:41:38 +0200
Message-ID: <1fff027e24110fe1692ab8bef06da99b31391b00.camel@sipsolutions.net>
Subject: Re: [PATCH] um: Include linux/types.h in asm/fpu/api.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>, kernel test robot
 <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	linux-crypto@vger.kernel.org, Richard Weinberger <richard@nod.at>, Anton
 Ivanov	 <anton.ivanov@cambridgegreys.com>, linux-um@lists.infradead.org
Date: Wed, 07 May 2025 07:41:36 +0200
In-Reply-To: <aBq6X-UYlQG9HUQd@gondor.apana.org.au>
References: <202505070045.vWc04ygs-lkp@intel.com>
	 <aBq6X-UYlQG9HUQd@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2025-05-07 at 09:41 +0800, Herbert Xu wrote:
>=20
> I'll add this to the crypto tree if it's OK with the UML maintainers.

Sure, seems trivial enough and nobody is likely to touch that file.

Thanks.

> ---8<---
> Include linux/types.h before using bool.
>=20
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202505070045.vWc04ygs-lkp@i=
ntel.com/
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes


