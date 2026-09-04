Received: from mail-43166.protonmail.ch (mail-43166.protonmail.ch [185.70.43.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962813C378A
	for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2026 17:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788544194; cv=none; b=jBUj/UD6eFsXUfwGpUm+9PLZz0Q8YGqWplvrJm7tCgtamIhdjL5qFEU7SLeGookTG9DUOdjq+6wKsuPE2FMgr+bRwO+R6w51fBXX21UqXG9f4KGLdHLA9id/0no591PC9tU3INhFRJZdmIl99OmdvksMtcRtYxftBa6tnW2Wm8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788544194; c=relaxed/simple;
	bh=2wPM2SD/mk6tOrkOoFFol9iN580eS9IararaXA4Qnhw=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=oG+sfygjf+MQEHOELLmNLPWXNgT8Arvg999u/jmbjuMrOInX6KiD69g/fuOgexOb9Di2nJ1CkvCkY81m1njP8YrQiBzsFGrvtJrpKTwJoFyWm9uVdzUOCU6UwcJtcrcXamKucez771b99DNVmY9B9otlWESOBrZrUz+WXBPOf5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=uJi9De6w; arc=none smtp.client-ip=185.70.43.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="uJi9De6w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1788544184; x=1788803384;
	bh=2wPM2SD/mk6tOrkOoFFol9iN580eS9IararaXA4Qnhw=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=uJi9De6wKHedqSpd90udSYiPxPXj8UWBgkka9yodl+HgTVYQWwiM/ww0cgKQ9Cg1e
	 P2kZOK18Q2u4u80izVQ+cBJmP51kF6fhYqNb5gIvE6qHKFA9r4m2dfTNY2Cw1APVH6
	 fLUxM2IsmocYl8/DeCo7fIM1MrFuJeVdjcyIjI0zHdZdUKoTTpco1BI/bLT5I23Zc0
	 IIziyyz0dJNZA13YfIX66JDwoUl8vD1KYgzPfvBCHdC8LlXAkHGYKLmo3VT69Ouwb2
	 R6Txy5l/fZ8VphguGoHqw+q0C60KZNd179CgY44Ios/9LOq5VFpEB3Lpc1OWweuhBE
	 p0VFzjH2PQo/g==
Date: Fri, 04 Sep 2026 17:49:39 +0000
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From: Jari Ruusu <jariruusu@protonmail.com>
Subject: util-linux-2.41.6 and util-linux-2.42.3 patches for loop-AES
Message-ID: <wFXL4pWV_0iwPeg26_64yjz_cP8bx6U6x4yJR1aec1fiVybzXZ4aq0nd946KrfSELmMT5rkeuccGyLkfGkCwGQYiS5VbWYCUETpW_yrJTAY=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: d7c78369dba57a72f53a48877632384c5d8f0d0d
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

https://loop-aes.sourceforge.net/updates/util-linux-2.41.6.diff.bz2
https://loop-aes.sourceforge.net/updates/util-linux-2.41.6.diff.bz2.sign
https://loop-aes.sourceforge.net/updates/util-linux-2.42.3.diff.bz2
https://loop-aes.sourceforge.net/updates/util-linux-2.42.3.diff.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

