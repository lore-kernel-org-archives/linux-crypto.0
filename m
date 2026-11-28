Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795840855;
	b=YMyHfnkv97gPuEGfKInVhRHD9PC3Z0Kd0noGrAmMdXS6TCO8kgc3LhqBumvyzhMdNiKB
	 tulwe0Zyft2WTGF2428EzlwPMjyq/4Q/9nHK7rrJQIT5orZ37oQperOYKqNnB1po36Y6H
	 MmU64kwTyWDs1aYNiO8H/7QHOCOT0zqxyqhYAjRrKgnt3QFWQPnTij4v8eh6vkPTcpxkV
	 If1JvEf5HmwREixQ29TWgKvvo9FIuORnySWAFC7uUQ6pc6e7kaLaiH9z3p2dKAOJVE9NG
	 ESUx/kNmiaQYeJ0aOxG8oSBY2sEX7v0lWMkiUwEZ/vpJ+uKcGE9wnEbgvSKuPlUvUVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795840855;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=44Vt/f/9Eidg4LLHAGiZfANvWFFz8txu28uEAmthn6o=;
	b=1DCcSnvunpZ1C2o6D4NiIu/KzX7fjlaklwI135tR+VqBelR6NkvpeaC+z0IiASmE25Xy
	 loF4mFujV4yLySVCsHmpTaPjfXzSXWVqso/palzQVKPaFwvX/htAbAzSPpMTgDUnTlRuC
	 JuGudFiLk4Wrt2y5Z2RobZGeStXUfUiQE/GnnabtBDo48zJqBl9sPH+BrVU/P6APtOk28
	 YOV8qEQztyv10LZDj1aYVFzEJwCzDqyIvGzj7TLzln1sDVPUewXHK58T5l7wHRRjPBkhY
	 V5IceXiV6vddf4U7zvx/1UJFitaEfl1t+t9zayx5/GelnK9mh/ksmqsKVwBEZafLoPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="p/AILqY/";
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFA0606A324
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 04:40:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDFA0606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p/AILqY/
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cde827b7b95so2926141a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 20:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795840854; x=1796445654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=44Vt/f/9Eidg4LLHAGiZfANvWFFz8txu28uEAmthn6o=;
        b=p/AILqY/OIBgnnXGmjW6+BbVfMlZ0LGIKESGWM7artY+c6Ooo0TKByuZ37Sk1tSOcz
         jdO1l9YpvmRQIT11jSnbuJu4MP84LQbrKa9IE61PEm2MW/TgA/IXNByHK5xal6pGz4j1
         voCL6CcyjAnLweLrvC1h0Sz+QE4+QgaF90fctw5DIDiAAiu/n2mu7nDluHKVD2beIxfW
         GL/Uk0G0/SchSC4X1YYrcCWXxVPHieCoFAKS6NYW7RT4GR66o0NDdOcHZlzkYlO1MBoX
         Tv4lewkJHN85bQvtaxQEO2VYtrPp0tNdIvSKRUSE+uoi4/Cu21i7c29YiuYOyfvgyffb
         IBZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795840854; x=1796445654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=44Vt/f/9Eidg4LLHAGiZfANvWFFz8txu28uEAmthn6o=;
        b=C9s9Iga1gBTPSWO6wKjqhg7N4xP53fzLyrSoAno+uJk0ueWB5OYM02ZAXU+x9kXtlp
         mk65U7wnaMDoYbwxSdKJ1XeuQ7mdxy2WQoJ2gl9M7db1mK3NXuaWbUGNa5H5wqZ93QkG
         pGjVm25MIUgFSQWYmIzDr5m14rVowsko3AZzIursYavIMj6DG3Vzh58lcvLSJJz9k5Lo
         A1R2bHaEWC9eAlD254hrPjlpyQzp3Pgv+VLJNm7wvNrW3lP5t17IxbMhBdWAFa4cq6GR
         /74Gf5dasW2tPEZRRegdnlJzBMQiGcrH3k9JC9ljKuXCXZjD/uBTXhHEyPxgsiZpgGrT
         ksnQ==
X-Gm-Message-State: APuU4Z81/TEJS7ulz4drCEfhguvTrUKiInRElFkTFOwTxFDyjOqRHgpw
	5nhpcLFiJ4Zfr8smH+R/tQRrEDEiJO3tLWqqYP227Sl608mIyVOtsHTd5GNRRg==
X-Gm-Gg: AZFdTZebT6vjh5sYCWNOR6aWg0LdezCIaC+lPnIV/smNcSU75Nf6TwJ5Ow0Tc1PxeH6
	SrB3x32P+kcZXZ1skesNIk/KwEZoawQY2jCWD4L6c2dtuMj9Gw2QvCMsX3OfFVEzCk+SaX/qPRf
	DLCNwdTMNIg8xqIZZiNaINSCFYmGlVfO+K2GJODtOMxCJAt1S5xZguBmYsMaqc+QqGlvgg4HU6U
	wZ+VQk3VK2Fv2CenQumL5/kv/Z9sVjhqFe2XjGNBSG8yAt1jN96m9/24OEFiDmlgjOYdo+hDAPQ
	fqjUW8ExvSPER0m7b0f5NTb3+g1aVYh9jJf4gF/JrDxRvY73oNmy+2/udqTRulVQ2crDxMUEpMd
	zdsfmEZr75hMawOUwcIpT+bJMK8/O1BY6DRqr+j2zWPbZ5sMT/KPMGGalWTNvAC/JpHEEIVLdyc
	rDNXNWgmfMuxyX60cYmddEV/auqGoxSxWoIWNdqrkdN+2NJ+cjkA52ibIdmICoUx5m7P6qxvPC8
	bP4GqHFETfAGcAO4quqq0mIppvaSWDHdCyqMmNmjuRuTL7A4gtaBg1HaTfpDOMTD9ib1blKXssg
	6oDUMnYhKKufQ5im2twU5HtsR1EoBw2TUH8eqTysTZyU1iWLh0W9Rs0thgi7kGVIz/Cbnir0gkS
	neKmerzOjMe1T3xW5ikozKl42+zFRq9JcRPgh5fWtgKcFFYxj/4tTf22rdr9vQgpH6X/5gclTIx
	xG4A==
X-Received: by 2002:a17:90b:3810:b0:3b1:bee2:223d with SMTP id 98e67ed59e1d1-3b41c9bc27emr25837489a91.53.1795840854021;
        Fri, 27 Nov 2026 20:40:54 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm42716729a91.1.2026.11.27.20.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 20:40:53 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Romain Perier <romain.perier@free-electrons.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/8] crypto: cesa - clear the IRQ affinity hint before freeing the IRQ
Date: Fri, 27 Nov 2026 20:40:43 -0800
Message-ID: <20261128044050.722617-2-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261128044050.722617-1-rosenp@gmail.com>
References: <20261128044050.722617-1-rosenp@gmail.com>
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

Commit 8dc981ba2fad ("crypto: cesa - remove irq_set_affinity_hint")
dropped the calls that cleared the affinity hint on probe failure and
removal, on the grounds that the IRQs are devm managed. devm only calls
free_irq(), which does not clear the hint, and __free_irq() hits its
WARN_ON_ONCE(desc->affinity_hint) when it finds one still set. So
unbinding the device, or a probe that fails after the first engine's
IRQ has been requested, triggers that warning.

Clear the hint from a devm action registered right after the IRQ, so it
runs before devm frees the IRQ. Switch to irq_set_affinity_and_hint(),
which is what the deprecated irq_set_affinity_hint() wraps.

Fixes: 8dc981ba2fad ("crypto: cesa - remove irq_set_affinity_hint")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 564b09773507..ac4fe783735b 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -415,6 +415,13 @@ static void mv_cesa_release_sram(void *data)
 				   cesa->sram_size, DMA_BIDIRECTIONAL, 0);
 }
 
+static void mv_cesa_clear_affinity_hint(void *data)
+{
+	struct mv_cesa_engine *engine = data;
+
+	irq_update_affinity_hint(engine->irq, NULL);
+}
+
 static int mv_cesa_probe(struct platform_device *pdev)
 {
 	const struct mv_cesa_caps *caps = &orion_caps;
@@ -519,7 +526,16 @@ static int mv_cesa_probe(struct platform_device *pdev)
 
 		/* Set affinity */
 		cpu = cpumask_local_spread(engine->id, NUMA_NO_NODE);
-		irq_set_affinity_hint(irq, get_cpu_mask(cpu));
+		irq_set_affinity_and_hint(irq, get_cpu_mask(cpu));
+
+		/*
+		 * free_irq() warns if the hint is still set. Registered after
+		 * the IRQ, so devm clears it before the IRQ is freed.
+		 */
+		ret = devm_add_action_or_reset(dev, mv_cesa_clear_affinity_hint,
+					       engine);
+		if (ret)
+			return ret;
 
 		crypto_init_queue(&engine->queue, CESA_CRYPTO_DEFAULT_MAX_QLEN);
 		atomic_set(&engine->load, 0);
-- 
2.56.1

