Received: from mail-24424.protonmail.ch (mail-24424.protonmail.ch [109.224.244.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38053372B41
	for <linux-crypto@vger.kernel.org>; Sat, 26 Sep 2026 16:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790439281; cv=none; b=WyoBSdAndV+smlR1HDy7vDgb+EZpwUZ6pwR59E+5CmdBibU7ELWamR3owu123u3B2f1AF0YAjMb+VWFFqrWK2hPFphF1/Xcekdls8zzOoHsOrvSD0OKFF9gaUWXwaW0DdClCHr4b0aNDrNyZ6wc3MKwbljZlE2pvg9p3elj4a4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790439281; c=relaxed/simple;
	bh=wllISWjqqTYJHN4fvsiJwIAJx/RKeNluHlu/aznKa6Y=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=tOIKatB5D7GlUL/eLJ1zG2eWzPPzjHCzgKuCEdaOURdHkOxVDkQf7HatnRNE01KzZHoP56reVeXnNaoraCfjFfrV+BnbtpTVUGHxNtEG6IJl0aSBjyhGYWiwhA0x23AXGT7h/rZ6FsHQz2WRYg4BjGcHoyqMY42cEjGhELPj4Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=b5NV3GWF; arc=none smtp.client-ip=109.224.244.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="b5NV3GWF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1790439272; x=1790698472;
	bh=wllISWjqqTYJHN4fvsiJwIAJx/RKeNluHlu/aznKa6Y=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=b5NV3GWFZ1UYbRcj2DXQ3a9Gu6ohGZv6bvsnXDdiRNaYkL6G9DKIzIj1ojVxZTZyL
	 9eqeoFaJ43eCMYFx8ov6pa9VfIyDK6EvYqKYF5gh7N6xqeflFe0RS038Ayrc+QtNV6
	 mFBY1rwzmeAX+XPo5J8f0Y6Vc+RORKLmlZu0G+Bl0Paz6Re2jymgl9qc6vKtAdH2Ep
	 r64Pwu15Xrva3Y7EodsDMQtgQutv9s0szgE+76Qay7r/jn7s7xJ0T8z/ahQURLB1NS
	 PuVCV5m1tKMucWJfmE5lzJCmdpgT3Ffo6ecSfTZv5DsGhLHYJSAPmzvY2BiW5wDl47
	 eIuiQfKjpqNKA==
Date: Sat, 26 Sep 2026 16:14:30 +0000
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Jari Ruusu <jariruusu@protonmail.com>
Subject: util-linux-2.42.4 patch for loop-AES
Message-ID: <faoyDu0KAMKBXQYUoLAI33mZ13s-i50dcenpDCG3tYFyB3WaEoBeDqFo2mui9m2Gtk6zm7TufcpzGS7BqEcyTXGsu2FHRvGK3b1-bm6NYjg=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: 9c0b784717fb582ce20ad4da54e7f48a4e2774e5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

https://loop-aes.sourceforge.net/updates/util-linux-2.42.4.diff.bz2
https://loop-aes.sourceforge.net/updates/util-linux-2.42.4.diff.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

