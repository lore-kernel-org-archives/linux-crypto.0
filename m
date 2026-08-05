Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1D038E13F
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 14:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785940607; cv=none; b=I4BNZoWgzi706qLwQXSL4Pr4dLpfoytofa177gmDTOCfyXLBfW97ezgE9lddTzOEKtgG7J4PyFDePVB6VsXZ9WVuWT8krXp7Hs6GuWlYBg+irkGEYz0IM+gqTBK3/ygrNKcTs4ACnaOLijhL6evU3Ixk4OTBMvDWY1uDfthOGTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785940607; c=relaxed/simple;
	bh=Va4ivm8VFtFpcxvPb6V6ItS1fIrbnCGVzIWgl1id4oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5ltDomBcr83jwvSThKva7KFcTYjlnTbYKc+4AQHcu0LCZ4GgNJ+QDQJbRkOTZzY/I5H1gMEsbfDF9YJ/EKW6XjONRI4Zs1ciBR46x4RM2VQjxU8TBW4mQ5Q1cWuQ0N94bVVj47KiqwnlRT513qbHV5Jh5xWD7V4JwtiqWz6ZAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eu67Iywy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eu67Iywy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785940598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EEtweso52u7DPd5Sbq00gxh4t8XgpNwiiYdVWx3jMpU=;
	b=Eu67Iywy+j7RpxZoJ+ap3Ovl4qow8q3SrkxVPexqfF9skniiU/F3eRl6x2rpTxLLSNcfje
	Oy9Vp61xQZObemptqrW5PQp13m2hV870J/NfS/W9Oa86NVeUR8Qt3kepZYy2YlrZyP2e35
	UyilTQlafDlgbR1g9Ibalfff9uCUV7o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-NHoGUniKNH-wvTHsUNYRTg-1; Wed,
 05 Aug 2026 10:36:30 -0400
X-MC-Unique: NHoGUniKNH-wvTHsUNYRTg-1
X-Mimecast-MFC-AGG-ID: NHoGUniKNH-wvTHsUNYRTg_1785940588
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77B011955F24;
	Wed,  5 Aug 2026 14:36:28 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.209])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D311D1800598;
	Wed,  5 Aug 2026 14:36:24 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org
Subject: [PATCH 3/6] net/tcp-ao: clear the aes_cmac_key when done
Date: Wed,  5 Aug 2026 16:36:06 +0200
Message-ID: <20260805143611.818559-4-thuth@redhat.com>
In-Reply-To: <20260805143611.818559-1-thuth@redhat.com>
References: <20260805143611.818559-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

Clear the local aes_cmac_key structure via __cleanup() function
when we're done with it to avoid that sensitive data could leak on
the stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 net/ipv4/tcp_ao.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index a56bb79e15e0e..12c724fed8a26 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -141,7 +141,7 @@ void tcp_ao_calc_traffic_key(const struct tcp_ao_key *mkt, u8 *traffic_key,
 					traffic_key);
 		return;
 	case TCP_AO_ALGO_AES_128_CMAC: {
-		struct aes_cmac_key k;
+		struct aes_cmac_key k __cleanup(aes_cmac_zeroize_key);
 
 		aes_cmac_preparekey(&k, mkt->key, AES_KEYSIZE_128);
 		aes_cmac(&k, input, input_len, traffic_key);
-- 
2.55.0

