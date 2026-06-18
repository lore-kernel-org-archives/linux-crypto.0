Received: from mail-06.mail-europe.com (mail-06.mail-europe.com [85.9.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92564348C6A
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jun 2026 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781803554; cv=none; b=ObQLiCNXgHDrF5EocP6q3V3qPiU4xlXJvOMtwoEUQkJSUd8VXveMhSE8npUbw5pc9I7m/8ee0HZFRRGuZO3aGp7/zdAlkHq982xXx0T2/yko3B0XTHE1CBNlHXePymYmC2/q/znYmWA909F7nHZY8+/7Zy6BnCHv9/q4aRF4HAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781803554; c=relaxed/simple;
	bh=FI84in/qUTwLIw4sMW2RsNS2IDX9I39pzBqnTl08KIw=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=EkBxi+4vK8b74qhf3jVapJz+zbSEwBDb063+mH1oHfGEonOOJNQx7x0DOBAr7vX8YdWgNCIS7VbbmCWYVfWRUzLTUAczVGmla2WCRg+GIOFqq0cTSGjQNSbjKUMFTCLBVc15L8d81hNWPPjdxFH/7+k2KQ+CySw5clGaa8NN6ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=Jussoiv/; arc=none smtp.client-ip=85.9.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="Jussoiv/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1781803534; x=1782062734;
	bh=FI84in/qUTwLIw4sMW2RsNS2IDX9I39pzBqnTl08KIw=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Jussoiv/9GrQiFH4bda3GHwSKNf9snY8cU1VaEtMSVCKD/br8jR6WY/oF3mFQ+loI
	 kWrjxBE320Df9JaPqM+UPpVIHXNu5x3EYroz4u989wlc0vS4TA1XD46LJi4ZCq3bPR
	 hxXnVHuva9pemjyV72BgOu/rlWV7QRCNjYcL26g6q7hzsPtWBqh5FDq8b5i/XmmQDV
	 5ZwfiHJWhs/QIKLyg+F7kZRYR116Pk1S8ZPl8vur2e2oWXTIa0zLzwHedwTNTo17to
	 myDWbCkpDCFqtnL5Rq475ucF3ZbEz3CkUI8HOwD4kXc9OxcBnkmP0kXMlC3525o4eT
	 61kArC3YyPW4A==
Date: Thu, 18 Jun 2026 17:25:29 +0000
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Jari Ruusu <jariruusu@protonmail.com>
Subject: loop-AES util-linux CVE-2026-27456 update
Message-ID: <yneXzkMSsVuGoERXJ5kn8dO8l1TEDVeNK6fP3DRtz7FtwhxCQ1FKLypgaqoLVsl932J5PX3xLrL7QPTPR6yepa6tlnCVp5VwFZWM2raTxAI=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: be82ff481ea83de443ee3ca1be71a3f78fd58f08
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Earlier loop-AES patched versions of util-linux have incomplete fix for
CVE-2026-27456. Newer versions of loop-AES patched versions that have more
complete fix are here:
=20
 https://loop-aes.sourceforge.net/updates/util-linux-2.41.5.diff.bz2
 https://loop-aes.sourceforge.net/updates/util-linux-2.41.5.diff.bz2.sign
=20
and
=20
 https://loop-aes.sourceforge.net/updates/util-linux-2.42.2.diff.bz2
 https://loop-aes.sourceforge.net/updates/util-linux-2.42.2.diff.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

