Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764194119EF
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 12:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786107568; cv=none; b=AkWQ8zq+QZuKuyolp6BIPHWeb9rDBHLuFWQEvPVqTpyHpqOE+XCHCU0NNHPLIh+DpTceZJTyKYKP8ZXWI2muBHxhAHDTNJ2aV37eGvYRMMXR2nPVnOmvzlmsWzvX9mD+q/GSiExkuX3MSATKUBOhWcUVhW++Nu4crG1pTi4XFuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786107568; c=relaxed/simple;
	bh=nB9PeiYqtYxB59Cpiw4+izGx1h8kYfW2R3OcHeWgats=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QY252IcNR5FZeFSOUiSIUTphnUI7kDDSut7KnqDLgokyN4swSSrVfe72ipKCD2e7u1DtBp9jcEac215b3b7IooVWdvBRn2Vj8Jk5QuvzWBSjiepO4A+ddIUbQ9b7ajDTIgVYmSVktoZCFyQcuXeWQyBw7v9nI3BOCpysKQN8dSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OlQOTixK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OlQOTixK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786107548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8M7wXURrhkNZfyuEwKvTXxWNDng8ek7UYAiVlFhlORo=;
	b=OlQOTixKGPEpP7p/CXf9DzmLtycDrMsqpIDylABsfXjv7Ssg5jhrpGrODFpwS6xa76A96Y
	Npv6E+ErxlD7GlslS+64K3eO6x0qZZT4Ij9btxj3VRebps1huWkkju3AE7Ee3xvuEupiYw
	Ld6yhVr95ibC2zo+/Sjc5mamA/ujIlw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-pasijFAYP1-GQ_F9r9GQxw-1; Fri,
 07 Aug 2026 08:59:05 -0400
X-MC-Unique: pasijFAYP1-GQ_F9r9GQxw-1
X-Mimecast-MFC-AGG-ID: pasijFAYP1-GQ_F9r9GQxw_1786107543
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 598A019560B2;
	Fri,  7 Aug 2026 12:59:03 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4E93A30001A2;
	Fri,  7 Aug 2026 12:58:59 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org
Subject: [PATCH v2 3/6] net/tcp-ao: clear the aes_cmac_key when done
Date: Fri,  7 Aug 2026 14:58:40 +0200
Message-ID: <20260807125845.1477067-4-thuth@redhat.com>
In-Reply-To: <20260807125845.1477067-1-thuth@redhat.com>
References: <20260807125845.1477067-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

Clear the local aes_cmac_key structure via __cleanup() function
when we're done with it to avoid that sensitive data could leak on
the stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 net/ipv4/tcp_ao.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index e4ec60a334963..0626cbf60620c 100644
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

