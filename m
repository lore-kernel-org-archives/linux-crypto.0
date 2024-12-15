Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7827D14A90
	for <linux-crypto@vger.kernel.org>; Sun, 15 Dec 2024 07:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734247650; cv=none; b=fO3MNm10aapRBXKkRitgvDeeDKavJaibFM0F/CtCneiu3oPxuXWmHTNJHCCkS6UkOgVKJAZ0V6T4Fkw6NL75gYVPJAp0aZ2BeSpBFF2YUI+q4FZXeWlHpA1wr9OtYHh+dUollNEoL8gQzMfkWcVpklSYPI4flG8cPOEptjnym20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734247650; c=relaxed/simple;
	bh=tHh2vbdQGSGDAh7ORzXWOKIeAcntQYuHDwTJ5ECZTjg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GZiBczIF7x2JROM9Vm7PW7rO9hvMUq02Y7iv4eOfSfL/6RMyJQ0o2IDk3WrG4ftfhvXUu0wzs9JGcsqouFQKGjQioeCqIQIUtNgDIN02v70tS8g60dn1hgdI5LvLp55YbGURA6qNtf6SNrK8P7Joy1scUyyLwUhdAPTRuL66LjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=pf.is.s.u-tokyo.ac.jp; spf=none smtp.mailfrom=pf.is.s.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=pf-is-s-u-tokyo-ac-jp.20230601.gappssmtp.com header.i=@pf-is-s-u-tokyo-ac-jp.20230601.gappssmtp.com header.b=pY8ad9XZ; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=pf.is.s.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=pf.is.s.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pf-is-s-u-tokyo-ac-jp.20230601.gappssmtp.com header.i=@pf-is-s-u-tokyo-ac-jp.20230601.gappssmtp.com header.b="pY8ad9XZ"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21675fd60feso33057295ad.2
        for <linux-crypto@vger.kernel.org>; Sat, 14 Dec 2024 23:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pf-is-s-u-tokyo-ac-jp.20230601.gappssmtp.com; s=20230601; t=1734247645; x=1734852445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zeNNxWMGeOZVK9C8bhmq7eNlUoSgikSfdTQc8osMwTs=;
        b=pY8ad9XZ1LOOPXE79XQiv1G4XVL/u5OsrrY+j3ObEcFnd6N2LQ+eQSrc4pp9wiJetl
         syOhZI+6uLYZ9z8gBUjMh7XoZvBYXjoCG342BzEBZNQvs/4pToNtG3+KzUkJSOT8PKjO
         3OOQl1yE9msopRR0D1fYjsmV0nbV3kxSoxJukzapuTbnB2Y5Co/lbmVbVdJul3w1r1w+
         yGel9XQkde51xc8u+iB8Bejeju1AKndzxJoNADWfIdoWuTMaHrHnnc4cSTmdU1yNy28o
         DB3VSRzOvH6uwnGCf1ThEOiGuImU5jyJyV6GgtXcQF83xqqnzI0BrEsWAPSHskfGCNu3
         WOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734247645; x=1734852445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zeNNxWMGeOZVK9C8bhmq7eNlUoSgikSfdTQc8osMwTs=;
        b=Gepft9iV1qZtSkHluj0vp8A0Aml3Wp0dSO/in0H+gXpXbCHeKVfyUVzRRkvD6vuLcp
         ZVim6FDmnX+M9/ceSUnKb3+uUMI9NGi42SbITmZl+TxDWcYaovKKKG1Wl/xIRE7vZkr4
         pn60VfI4SyU+eyAdyrxN3eqHEmg8iaPvz7M/tKVfH6q3ujw8eZSqERUYQqtuZ4GepaR2
         +wvuKDNs++lHUpqeaLDP9O4+6yRsWbeYTVdYr+zFmSvfuo8FOrbmP6tj9aJRRFyvFbYg
         s1Rs/yAbmGNQjlwWKT2KXEwkY8+VomID/ewccBIyRzcesdEtb+JfUANOCqgEA+bJOdbF
         fkAQ==
X-Gm-Message-State: AOJu0YxitGEbvrnzlNobp1895GW8dfWhCHCw7ptwUpbFB1KVaL1mHswn
	nsRe1K6W6hf7t/5z1LP5xwMJVZKQbfdwg0RgcpJw/QDSFxAcM3K7ystcLVNGGawEIDMk/q47ECb
	UFxLOxg==
X-Gm-Gg: ASbGnctMD+5llPzUGESKHEEaij5CR5NfbuphJ4tYllZfOgEjPtC4nVdVTfMTMXVI/Vp
	q0HJhnNwdJ8NWFhku+MPWXO22XFYJzHcCYKS1m+0GdYFtAEubiut9RokfwOKN65o5Mjt0AccUlz
	+/OF6CMFL3mZn3GnKH4Msp7B6iKd02txpMIWL/urV8hkMG2jkoZvSWNL2tqc4ZbV0fEfRBOa+ZP
	5OKLQtYIiynprE3JfapDbV3D4Ne6cbNox4+qniD+4sXoQiS9b7LT5h0TmrJ5tgcVj1LUoc/H6qZ
	XeCw
X-Google-Smtp-Source: AGHT+IHBO2Bz1jf36z1IobMzA/6bUz1v4+Eos/4ZuJ0hfFHWTlu6KLhgaIAy42bM0hPJhdux1GyCNQ==
X-Received: by 2002:a17:902:db09:b0:216:48f4:4f3d with SMTP id d9443c01a7336-218929bdb34mr116890005ad.13.1734247645176;
        Sat, 14 Dec 2024 23:27:25 -0800 (PST)
Received: from localhost.localdomain ([2001:f70:39c0:3a00:39e1:57de:eaa2:a1ed])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1db755dsm22400555ad.42.2024.12.14.23.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2024 23:27:24 -0800 (PST)
From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
To: clabbe@baylibre.com,
	linusw@kernel.org,
	kaloz@openwrt.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Subject: [PATCH] crypto: ixp4xx: fix OF node reference leaks in init_ixp_crypto()
Date: Sun, 15 Dec 2024 16:27:20 +0900
Message-Id: <20241215072720.932915-1-joe@pf.is.s.u-tokyo.ac.jp>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

init_ixp_crypto() calls of_parse_phandle_with_fixed_args() multiple
times, but does not release all the obtained refcounts. Fix it by adding
of_node_put() calls.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: 76f24b4f46b8 ("crypto: ixp4xx - Add device tree support")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
---
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
index 449c6d3ab2db..fcc0cf4df637 100644
--- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
+++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
@@ -471,6 +471,7 @@ static int init_ixp_crypto(struct device *dev)
 			return -ENODEV;
 		}
 		npe_id = npe_spec.args[0];
+		of_node_put(npe_spec.np);
 
 		ret = of_parse_phandle_with_fixed_args(np, "queue-rx", 1, 0,
 						       &queue_spec);
@@ -479,6 +480,7 @@ static int init_ixp_crypto(struct device *dev)
 			return -ENODEV;
 		}
 		recv_qid = queue_spec.args[0];
+		of_node_put(queue_spec.np);
 
 		ret = of_parse_phandle_with_fixed_args(np, "queue-txready", 1, 0,
 						       &queue_spec);
@@ -487,6 +489,7 @@ static int init_ixp_crypto(struct device *dev)
 			return -ENODEV;
 		}
 		send_qid = queue_spec.args[0];
+		of_node_put(queue_spec.np);
 	} else {
 		/*
 		 * Hardcoded engine when using platform data, this goes away
-- 
2.34.1

