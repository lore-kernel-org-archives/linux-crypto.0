Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795405035;
	b=vQfimer3sw+JpOJoI5g5VTGGRRJI4ZjUMesHjGt4/V6DGdUSwk2pn+eFG2QG3eEz28TG
	 ePZGyHpgBztpIbfdDOgqGABmEXcYun++Tq/XOhNIPmxtivSu+CwjzrY08e30M6DsmqVaI
	 GZujRDESPCQ5yVSyYZocnZPaTGa8pNDyXAoIYQuY0j/k1ZbJNfC+H0ZLLVhkXJiqnUje6
	 7VvYVL9Ur8AkI0HIeIdeNkTXE47wrR66fENkN13t8gRumKmtYoFCVX/DBUj0ycWtsefQK
	 /PFh8xpsEBjk2m/MAOT0ksX+PCMM5eQOvWTrLZ+6tukulsbX4av6Yc/JbZVhXa84cRw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795405035;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=urgi983F27Xme0kB19tBzgKbPaSnQ+/i5neowFMO6pg=;
	b=W6KTOYzl2+wqlZ4jj9kpJHyIQ+OAnsyAoT/TjOQ2oT0rF8jYxM9leAsdNPchf0p5cvJU
	 SMMlKYcYWatXTx7MwM7ku2fg8FvYqoWtLenVMymZ8Xw+qzV/CefRJ/MsCnf4BFxYCDyd+
	 3//SNLqYxvJdNv5+g2W3dtuWQVFYc/YhZnGKUkDzWGTXWBHHOsO0HH8/+CFjN6GDHBV3j
	 xVuIwaJw2rlfXmHX+Xxm/TQgtEY8XYZ3teQ0orxkwR4K1eKDJMWVy16DcTf5jG+41aqL5
	 1cgp1ymEEzQ0lQ5n2GiHwlEhH/Mj2spRguj7rO0Z15SNeEV3ERWYroau3mW2FIqEK6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=jdRimk2g;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.15
Received: from sender5-op-o15.zoho.com (sender5-op-o15.zoho.com [165.173.182.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF01606A31A;
	Mon, 23 Nov 2026 03:37:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FF01606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=jdRimk2g
ARC-Seal: i=1; a=rsa-sha256; t=1795405021; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=f95WSc3LYg2pOU6MbqkaYqjvj3pzcqlzLVHepQDuBNi56lV09MaLNmRCVlHcAuzR9u3wCAt0J8H1ZXM0MO5BA9Rdfq6ElSX43aAIMPLQCR6NJIiZwcrJrsHe2VxNzB2yTcW2dCfFwHVoCE/xlmKppYxuxwFoD53Wz2K/dKXKD9M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1795405021; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=urgi983F27Xme0kB19tBzgKbPaSnQ+/i5neowFMO6pg=; 
	b=BMswgyc1L1ANk+exO3lKcy6bV0GPATiutStlFIhlu+CYMuRjhlRLKfD9OjswgswsF2pxUPHV7QhmR3NpikEUcK6GzqDCozS4qsKnWmMRquTHM2/NrmcXkN+PJG4+qvWZC/q1cJWENzkm1Odtxbspj22HjeLnmxvQ3PoPjI8EQVM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: a=rsa-sha256; b=jdRimk2gOaku0r3grmjChHrLOxt39kgr4R1GMdWGbkQioL2nsUGgK+waYAKcx2zUQV/NFHtVc9TYr1MoAps6/+CNA28KcNKhJHqB3YTxHEea9sWhSXo8Y7G98c50JqmhjaqPPTzkjAR0+Gdg+kYEL8+mHcl8Y0VcScmAfRELUSk=; c=relaxed/relaxed; s=zoho; d=laveeshbansal.com; v=1; bh=urgi983F27Xme0kB19tBzgKbPaSnQ+/i5neowFMO6pg=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1795405017881212.13129883991235;
	Sun, 22 Nov 2026 19:36:57 -0800 (PST)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: Arun Iyengar <aiyengar1990@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Erwin Pawliczek <pawliczekerwin@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: ecc - Keep the random initial Z below 2^521 on P-521
Date: Sun, 22 Nov 2026 19:36:51 -0800
Message-ID: <20261123033651.91031-1-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261114-ecc-p521-small-scalars-v1-1-7b114f076b33@gmail.com>
References: <20261114-ecc-p521-small-scalars-v1-1-7b114f076b33@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

On Sat, 14 Nov 2026, Arun Iyengar wrote:
> With a 576-bit Z, every P-521 ecc_make_pub_key()
> call returns -EAGAIN.

Hi Arun,

I tested this on an arm64 QEMU guest (7.4.0-rc1, Herbert's tree at
8ba9044ff0bf, KASAN, lockdep and DEBUG_LIST). A module calls
ecc_make_pub_key() on P-521 for 76 keys, three times each, and compares
the result with OpenSSL. Without the patch all 228 calls return -EAGAIN.
With it none do, and the 34 keys from 2^522 - 2n up match OpenSSL. The
42 smaller ones are still wrong until patch 2. KASAN and lockdep stay
quiet.

Tested-by: Laveesh Bansal <laveeshb@laveeshbansal.com>

Thanks,
Laveesh
