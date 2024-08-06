Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5522015D1;
	Tue,  6 Aug 2024 05:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722923344; cv=none; b=MjULp7Ia/hvYf0RZUNv4wyv8F8X/PSxYzEdl9xHMa33O32fLbw1bht9ix+zr29e/c2rsz2W2YiLlD71RhCyWM5Y9KjISQ9epbhJiZBtHNp03H1n9ETSxu28FmwimIotD7tXatHfV50RUcYD+I6x81nEH5DpunybHfxLh6RZKwcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722923344; c=relaxed/simple;
	bh=r52wgsyMWXkd0w0zl1y/LGO+H0/Csu398YV7QeLpysc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmCrvI9csDdV2F9a9/7fG2zDONUBU/KbvQXk3HdNMyqOU5iytPm+0ak2pxDEydcOn4HNH8oiAq2QXu7G7088bpCrt2Lgt7R4QmTsWSowLSf3aV7QjtFaJcSBn9v9ztWy2C0T2/25XEkxBkt2gHnaQ7QVIM03EbziPsXY1iNl/yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sbCva-002iAN-07;
	Tue, 06 Aug 2024 13:48:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Aug 2024 13:48:55 +0800
Date: Tue, 6 Aug 2024 13:48:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Justin He <Justin.He@arm.com>
Cc: Thorsten Leemhuis <linux@leemhuis.info>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	kernel test robot <lkp@intel.com>, nd <nd@arm.com>
Subject: Re: [herbert-cryptodev-2.6:master 2/9]
 arch/arm64/crypto/poly1305-core.S:415:(.text+0x3d4): relocation truncated to
 fit: R_AARCH64_ADR_PREL_LO21 against `.rodata'
Message-ID: <ZrG5RwH-HVweqiaE@gondor.apana.org.au>
References: <202408040817.OWKXtCv6-lkp@intel.com>
 <4bba778c-79b6-49a6-9839-5f492cc4251b@leemhuis.info>
 <GV2PR08MB9206F98238936874A3A82D9AF7BF2@GV2PR08MB9206.eurprd08.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV2PR08MB9206F98238936874A3A82D9AF7BF2@GV2PR08MB9206.eurprd08.prod.outlook.com>

On Tue, Aug 06, 2024 at 12:46:33AM +0000, Justin He wrote:
> Hi Thorsten,
> 
> > -----Original Message-----
> > From: Thorsten Leemhuis <linux@leemhuis.info>
> >
> > Ran into the same problem today with my kernel vanilla next builds for Fedora.
> > Build log:
> > 
> > https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/next/fedor
> > a-40-aarch64/07852205-next-next-all/builder-live.log.gz
> > 
> > Happens with Fedora 39 and Fedora rawhide as well.
> Thanks, I've reproduce this issue with the kconfig provided by kernel test robot.
> Tend to think it can be resolved by replacing "adr" with "adrp"

I've reverted this patch for the time being.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
