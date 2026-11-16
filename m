Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794806496;
	b=QxuoNR0g8ZIlQhWXq0HzCionjKF+m/XqXkd5et96qfvc8EpxMfziXmhDYJ27jWC7MJuu
	 //crW8t+Bg0g76Bukox6Emg8jQsAuJcz24RQNfBXgKbdadDTj9uITxIkL0xtwvfEdSzGh
	 cNgzD4a9pnFWhJxlncQdVyar9q7Iz03u3GooYv5Z6nHhf6UVRQbex9hYBP1ELZZqP8yNL
	 lmKPxDhtj5v+xJBOQ2KgN0AYzulFI8eivOo8+yt/Nv3g9F82TBqmeFkRzASxud784T0lf
	 hF/nZ2KlI6cqgGKBl3s06T1doKIcRxN75nqfaJ3ajZCcnjvij2G9k+ojt/Yl0pQDxXw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794806496;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=wL4evpu/sMuCT2yjtCxtMs0Z2IjM+L4EnAdUbQ07bFI=;
	b=DDMC3cpCR1pA7BLZQIcYLi3BmxAuQAOyD3B5b1iEH6PSXxOro6mqtQi3dKqMOydZlMe2
	 QkipyWbFMhk/lPSa9L2wbwVPBBPj32BmOdvgAMmAJkmnXvB8ZJW/6M++DL+B5GNoq67uu
	 EqHrtj/N+eJAVz9PPeNBZzD//z9PZF04m/J76iMdotkkJQFE6Jp08UBOTk8KHy1WzyT5I
	 gJLPZahXzNlLXWelK854uAuY1100zIR38J+Xmrp0XMPSi8l+M73D0pA0Fq5ntRU+6pTG5
	 QdhmEgX/vIs7xJ7/5lQwlvWgH/lL3Eu2YlrCUgUM9ECphH26s1czwUenHK9GbfTBqzQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=XTLB4SwD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D81606A323;
	Mon, 16 Nov 2026 05:21:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4D81606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=XTLB4SwD
ARC-Seal: i=1; a=rsa-sha256; t=1794806479; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=cImJN7HjE2bR63FymF5AFkx+kBivXpVRzcJdaDSr4qBF/f1uWOSx1PLXUNrqpLMHRRrSYvNRZ2LDb/mMvUrVYipteu719lXm+WMympS6jppoGTwoFkgrT5pkypsqb6kOQ0EKZxsJz6i65Ju489VslVN3P3l3ODcr6FXJFmfYzsg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1794806479; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=wL4evpu/sMuCT2yjtCxtMs0Z2IjM+L4EnAdUbQ07bFI=; 
	b=VUyGzt4eaqw1lUPi4//YEqSwtPRy1l+bKL4N+sETKCiIlicMSd2Ge4mbeUoZ1Ca15x2YTw6yotzJbyJVDJUJkE7mbi/PQlYc3N0JZqxD8U+UlO9Q1jRa191OusgtD4qRpnvgXCHesKAhnLWjyQDXaq3T/R9JzRHS4HlIrJIURpw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: a=rsa-sha256; b=XTLB4SwDXsod8ZMTCvp3fmkZUnHs6uyjJHTW8Ygzhr9+07ctjlMUDNhWNXJFwVtdtTZDvSP8nY2iTeaF8yWPIngblrszfXW/80egDqkyZym6YRdFRG1unVnV+Xvx8oLDuIewMhZo2V3SoXi8Eh4uEYH/nuG0rA0GlkD86UlIO98=; c=relaxed/relaxed; s=zoho; d=laveeshbansal.com; v=1; bh=wL4evpu/sMuCT2yjtCxtMs0Z2IjM+L4EnAdUbQ07bFI=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1794806477346417.52595436202114;
	Sun, 15 Nov 2026 21:21:17 -0800 (PST)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Denis Kenzior <denkenz@gmail.com>,
	Maximilian Stahlberg <maximilian.stahlberg@uni-bremen.de>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] X.509: Accept a certificate with an empty subject
Date: Sun, 15 Nov 2026 21:20:43 -0800
Message-ID: <20261116052043.63530-1-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261112080906.GA375698@sol>
References: <20261112080906.GA375698@sol>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

On Thu, Nov 12, 2026 at 12:09:06AM -0800, Eric Biggers wrote:
> This problem (and many others) could also be solved if iwd switched to
> use a userspace crypto library instead of misusing the kernel APIs.

You're right that iwd could avoid this. My reasoning for fixing it in
the kernel is that RFC 5280 requires the Subject to be empty when the
name is only in the SAN, and the Name rule in x509.asn1 rejects that.
So this is a case the parser doesn't handle, not something specific to
iwd.
