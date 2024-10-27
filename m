Received: from bout3.ijzerbout.nl (bout3.ijzerbout.nl [136.144.140.114])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768141741CB
	for <linux-crypto@vger.kernel.org>; Sun, 27 Oct 2024 20:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.144.140.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730059261; cv=none; b=nYjoN3/FFNp6gJbhLgrS1YfI3I4XxTZNP7JCQCMUvhNWioaDhe9NKqUt3LFhjqY3e2Zks9AMjOtDLUK50m4GLRcndJr0yvFBdRfSlmt0CLp0w7wwuhAnu5+HyIA2TYjFylJIEMU7p4kl8fWKikwSbPzCR3Q1iycV1T8a8vmE/IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730059261; c=relaxed/simple;
	bh=7XeDDN+XQP89iuhlxtIPMUzSiWpNSNNce3JR6Gpu7Co=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=k6l51xWEizfreG1jrF8Oe7KLRmmNQO/+K4k4wjigFko+AkStgdp9ZCv2vOgfcWPNNP65t7YFXOe+ZigATKGxR9FDdW7D1csRHheOcDX3rXzKE83lJGX53PJ6SdnOy87IFJ4S1zabTThrcJD1Oy/z5Pg3B11AcxH254esqQe/cSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ijzerbout.nl; spf=pass smtp.mailfrom=ijzerbout.nl; dkim=pass (4096-bit key) header.d=ijzerbout.nl header.i=@ijzerbout.nl header.b=c/3xKclB; arc=none smtp.client-ip=136.144.140.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ijzerbout.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ijzerbout.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ijzerbout.nl header.i=@ijzerbout.nl header.b="c/3xKclB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ijzerbout.nl; s=key;
	t=1730059248; bh=7XeDDN+XQP89iuhlxtIPMUzSiWpNSNNce3JR6Gpu7Co=;
	h=Date:To:From:Subject:Cc:From;
	b=c/3xKclBotLzywWxoXr+LjPR+JSLNBxTJkN0LUFaSg87o0ldCu5fLnbT6ZpSABxeP
	 i2dJCHLUj9aREliPgF9a5caGoewuoLZqrb6W7sR2CeWXPdyrtWRloUCtOtXVStItNY
	 7A5MoSroCAhqjB4txFhSvA/XjXxODgY1oN5kD8MIjStk1Q5EdVzTQ+tcEsNq83VOIW
	 S9aasyv+kYvzSXSlxiWxJMvDgSR9g1LaPg8q4HRSRjiRGJhlGMImmMFBcjcPiTAFut
	 Y5fm+pGLX/qOz0AbYlzZZNvS+ySA727w+UKYn11IBiP1v18ew8zQW/f1sTUsloGotR
	 YTJdDONJ9HZypciwSqkCdAWCCn3A1jERifsZwuxtas6WHJjV3nbZFrOxstpl2+efBR
	 +UPSo+Dob7KmaI47ez4+U1ZXts3eXFZlR6YQXy10CRhOwpVSaU5rTA2/28ugrLg0hn
	 dtSIuhJpa36RAyOUZX1Z0OG866iXdW8ipAcLhI/WhYnKWyGZyHXEk5ppKStd4EXlau
	 KtA8caaclLB52uaCoO/GcU72ITw6yz1b8KtG2Cl6CMBj8HDWvdskFaWJJWLmkxHk1s
	 hcUWAMgB6UXDVa6uGTt23P069JhfaLY6GA0Jtglvdp+z2Mc2XuafH7dlfNHgyqv2DD
	 yGDHkvFmnn28SUUtCUVItyAA=
Received: from [IPV6:2a10:3781:99:1:1ac0:4dff:fea7:ec3a] (racer.ijzerbout.nl [IPv6:2a10:3781:99:1:1ac0:4dff:fea7:ec3a])
	by bout3.ijzerbout.nl (Postfix) with ESMTPSA id 61F4718DC39;
	Sun, 27 Oct 2024 21:00:48 +0100 (CET)
Message-ID: <a6c29470-2c28-4eb3-889c-88209bf45e01@ijzerbout.nl>
Date: Sun, 27 Oct 2024 21:00:46 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: George Cherian <gcherian@marvell.com>
From: Kees Bakker <kees@ijzerbout.nl>
Subject: Question about crypto: cavium - Add Support for Octeon-tx CPT Engine
Cc: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi George,

In 2017 you added support for Octeon-tx CPT Engine
in drivers/crypto/cavium/cpt

I just happen to stumble on this piece of source code.

static void cpt_disable_cores(struct cpt_device *cpt, u64 coremask,
                   u8 type, u8 grp)
{
     u64 pf_exe_ctl;
     u32 timeout = 100;
...
     while (grp & coremask) {
...
         if (timeout--)
             break;
...
     }

This looks a bit weird to me. The if condition is always true when
the while loop runs for the first time.

Looking at the code, I think the intention was to try max 100 times
to see if the cores were actually disabled. The current code is certainly
not doing that. Perhaps you wanted this:
     if (--timeout == 0)
         break;

May I ask you to have another look at your code to see if it is really doing
what you wanted the code to do? And note, the same is done in
cpt_disable_all_cores().

Kind regards,
Kees Bakker
