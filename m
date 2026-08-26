Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED6A3C1F43;
	Wed, 26 Aug 2026 10:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787740692; cv=none; b=VnwPc8yoqpcGIWtRqm2GzorFKbkBHnqL8JjG8IojxUKD7m4B6E4CP87w/83Xn0RllMh3unNJ7B45Yv1YSbVOxxfh+F4MQpMbnH8jt5lA8JF1GSzqFk94xEqDmQ2gnko8vlVW2NU8/Kg/w/upUohjnkyyoE8w9LDuOe/IjJwszfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787740692; c=relaxed/simple;
	bh=ZUiEqS4BLLJLSZxh9gbHN+gfYnXizSADiGb+pCZjtRc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WtFY9Mi7QKyjb5vQYSzlhLjteaJWhWPaazY0AZ9J1Y9EysHyjFzFf9YFU0sRoXf30qT+4OScZCkolFB5BmY2JWwZDQ5ECXP9AY5B5bYSicQVpDUvcBGB1ugfzfKZ/l/bzrTHaDzTugZs/dWxoG0aErw9UhsuRb37V947mkUDezM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=KISLnABv; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="KISLnABv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GEMfIYyqtvzwGjimfkWqFmquPszN5EzGTXyIKa2XdZM=; b=KISLnABvfCRGFCGcGArMb6QK7K
	7SzPsZpHbw2TrXRqXWlz4ujtmuXSCzYiQIugBc5dm47+Uq53McunDakyopMtDFI/WmkK7B9eQUpqu
	YVdrlSe/qZ9gogukbB9xD1o6j0axPG/pDyhrRTavTroxnYIVswIkZjOvMny1i8dHy1fawUPg55mFz
	pze2HdXVktiyz+zObvcF7+Y7lLEckJ/UdoXDIkYIusTXxQ1zLx3rR+p4HLzBARSg2vtIHrxzA3178
	tBjNtBk6sYmF0q0ZgcanKmohwOK/jLcHB7tCvv2rTJgAoVIw1mDGq3xfTk8hOZTM0ecfoYifLLvCk
	BuiYZ8tA==;
Received: from [151.115.150.205] (port=37352 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wzB1D-0000000GmVI-1AIt;
	Wed, 26 Aug 2026 12:38:07 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH 0/2] crypto: rsassa-pkcs1: fix undersized key handling
Date: Wed, 26 Aug 2026 10:37:42 +0000
Message-ID: <20260826103744.1554131-1-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

PKCS#1 v1.5 requires an encoded message of at least 11 bytes. The
signing and verification functions do not reject smaller RSA modulus
sizes reported by the child implementation.

This series include two patches due to integer underflows:
* one in the signing function that can write OOB,
* one in the verification function that can read 1 byte OOB.

Jérémy Jean (2):
  crypto: rsassa-pkcs1: reject undersized keys when signing
  crypto: rsassa-pkcs1: reject undersized keys when verifying

 crypto/rsassa-pkcs1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.47.3

