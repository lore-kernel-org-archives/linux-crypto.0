Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.61
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794587292;
	b=MeGTtwA2sd9tUaNIh9C9kyuhnoU/xtm14CphkBMRtcmjDDqyEIxToIJiKgGU3zCanbXW
	 ZDtSTArBl7w/ody5cEZ4M9Zd7FTeA9C6LNO09lKxNNJh6K6uka/taQugb8vK8zls6lpLJ
	 7Bkr2BaM9kXzRJkzMIjffQbIJduA1YLi/BAdxfgHUavTWLiQDVGRFacMovtvvAawSw3wx
	 AJ+H2FMxhm2WXNQz3EpBCKCsToIoLOUx+CUh05SoKAlRoSBnllsky2KN3x3q39vfrGabM
	 DhazG79gjlbxinwVPsVJ+EMrcz/BbHCSZ4cunByNVM8pX8hSf377oSDgnjIxWV6jh0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794587292;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id;
	bh=tOlvYcBwUhpqk/13BBmFCTufeBPDGQymskMs2i9cfbc=;
	b=E6qKD46AavMW4hXxm+cS67fF56qBoBe54fOmUy046Zgi1or3Uw1qqJgpibIRqtNtVcAp
	 CQGFhMaSJUrcPDl3njp793bvDEGgySzE0cX8+ZNPGXM4h7EEIuyPIVM56EnpNdcLdRUhU
	 HMVkIkVAt31C2OLEJnlYdcD0+HJ1dvLPNcK14cFswp7NagnGS/cuKfXVQ+D7+kgyQTz3T
	 B19oLMQ/aSLONvORSFJ6I0lUPjT8fiqNMuV4MU8qYlVXWF68PgiyKfdwMTDAFRBtE1EMC
	 ydT7vvDchw9WzZyNt7s6h6LIvkb/531qZwLOz9csL53g7Ao3mEIUX5ach7MUCsdYluQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b="wSZ/kX/U";
	arc=none smtp.remote-ip=195.10.208.61
Received: from mout-b-201.mailbox.org (mout-b-201.mailbox.org [195.10.208.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E862606A33B;
	Fri, 13 Nov 2026 16:28:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E862606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=wSZ/kX/U
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-201.mailbox.org (Postfix) with ESMTPS id 4jR2js5Vb0zLlrH;
	Fri, 13 Nov 2026 17:28:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1794587281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOlvYcBwUhpqk/13BBmFCTufeBPDGQymskMs2i9cfbc=;
	b=wSZ/kX/UyLKEEpZlXV8Tf89DFbTBNy1G3ePGh4RC2FcXVdR5dytwsfUzmRaGqIPnkAeMQy
	3Vjt8SaXqOvZoCu/eGT3eqvJgc+9qlecrRDJDponimxqzBPloywELNfzHh8naK8KURkJ8E
	15T0t48H6vKrp7iSb3PMSLOqJVjaaS8PTV4Qx5XKDkCqoSekVqfHjAAt0cosm0UBFSmuXr
	fZThX8/sclUtesFTLk6RV3eTw5l4mQvM1rTSboUrlWkSjtcWculi/qyPl421c3qPZ3c2K6
	BFu/tIGU0/DXt8+HpRAHa6att1fcOGeyKbTcoLHEJzNap/AHE8m8fqzOWEDdrw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of ralf@mandelbit.com designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=ralf@mandelbit.com
From: Ralf Lici <ralf@mandelbit.com>
To: Ralf Lici <ralf@mandelbit.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH crypto 2/2] crypto: safexcel - Map AEAD buffers with accurate DMA directions
Date: Fri, 13 Nov 2026 17:27:51 +0100
Message-ID: <20261113162752.186189-1-ralf@mandelbit.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261020120042.359215-1-ralf@mandelbit.com>
References: <20261020120042.359215-1-ralf@mandelbit.com>
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
X-Rspamd-Queue-Id: 4jR2js5Vb0zLlrH

Hi Herbert,

A gentle ping on this. Does the tested failure with the fully
DMA_BIDIRECTIONAL mapping address your concern, or do you still see a
problem with the per-entry DMA direction approach?

If the approach looks reasonable, I can respin the series with the
physical/logical layout and the A/B result described explicitly in the
commit message.

Thanks!  

-- 
Ralf Lici
Mandelbit Srl
