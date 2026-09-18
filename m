Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3714ABBC1
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 12:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789732802; cv=none; b=JkPqzD8NSte7SgJo8QtfWFgkUqE0aXHqdrNn3wEyMP1hk7yH9ctV7cr0du8MkmrP39KI7ayUf6CCV3SUSxjt4oaLclCyFSFglVRFmjuQgndv1mhMqizi/8TAtxZbG027Ibjp2HN3pj15PQJW9hWUPzs3SPFH7DB4BmncBudMhRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789732802; c=relaxed/simple;
	bh=txhqtuEPWi7nD3urKElDbbpKMOAPkwNT8dosnT1pZE8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gi796guVSDDEcUhlcum7ifk9U2JBuxsuOKcivzF6bJIkrtDebkuq1k989lG045Is+dJmYcXl+faoNckfexzPGl5i0hbbJ5Fb/9CuYypIAd3X5Ia+IjJ8cgxW4FNOeFmcj2vZ1/E9vLrac6ehenLu6ETZw6Vodggddn7wtmmDkk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mCiSmCRR; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mCiSmCRR"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc1cea50db3so325965a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 05:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789732800; x=1790337600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xYcJRra+LcCNHLwBdH8ymzEfMxOB7CWtfUUDK8cCiZQ=;
        b=mCiSmCRRXRTw81ytFymGzhKFcq+EM6p0FTeNRtVASeu7qaMcuILfgl42DAChfoB3RS
         S4mBT0fvnmc8ny+pLciMQ9F3Lkb4Rq4mmMi+5dX5vQTbZH6si3lSEcDnOAyP3sY6hNkr
         g2/H04cnZ7fW7XFYqV16nBQAkJoHRW26WiE4O5hnmzqseDTThD419+1VtdvEwc7yAawJ
         OY7SgH3n7YjJ1oJl4u2/yZ45ki4huvPd5vVQmohnmYb0E5vVjG3KK/RUuTkcEUFVP1VC
         NDgewBmjmiwr8dkCyXc+VG9SwrYp7jwo90Avt/NUGaEL+nMXyDCS1kSC2VIpIHgj2FT4
         GEdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789732800; x=1790337600;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xYcJRra+LcCNHLwBdH8ymzEfMxOB7CWtfUUDK8cCiZQ=;
        b=bhfFduRHAq2zr+2blx6OIuJGaz/HMZp1Sd8gmVhkk4v2nCZCFLHMh53HPUWIIVzzTA
         PKbT4ticREQq1bapr54FWR+HklDGPGPSUx5arzS52NAUSmIjwWlAGQraHKRSjWQOpV+m
         FgW+t1xELRmiL9H+VIV5aHGoDjMDP5tUGp2kBYXtsu3dVRDz+ITP4+PY5p8ZdoLoo9EB
         40nYPAO6i2iHA3msFUoHGFrNxmJZB9+w6+fjyhkI5kbDJR8EvPzE4eDm2A+tfECIzE16
         OzY+1HvjOEeXmMkgQgAWmfc8V+7ZzHsv1N6SGac3WAP6/NKWo7LeOCoS73pK1ShBVAcJ
         bYkg==
X-Forwarded-Encrypted: i=1; AKwUvBxtiCh1zUbFvbat2YJNCA8jUmGCGT+VuVxOPfAcdaYxTCzXYFrlMDWXZRagYV0Zy/vSY6bZlgwyd8QrDco=@vger.kernel.org
X-Gm-Message-State: AFuF++lnkqS1yz6q+IegL8t5hIeBWpsoPZ3zMi7wxV6Ox4UrX0qnhTLa
	9Q5TuQRA2VjaDfo4Rb4top0DdOMBGmZ3ZuGE+XS10m55GUnulXi5FoJl
X-Gm-Gg: AYBFou3/tiYbi9V5wvT79TzI6bwBY9SCpfNlGiUhyGrgB9peRVcuuko3McgldugDEQV
	O+pwfhtZPBMDv0q5lYLwC9QQ/eZjG+Zwd5UvE47as6w9TYZgzg9KoktAC8dqbntZP/YwcWT8fJG
	+ECT8yGq0XLFFw4od8bib4qyfjIsCcTU7l/85OnJxPhn5bnc6xfrkoWPp0lSOnkV9xWNGItQfhq
	PTmXIAA9XeeZxkhZINnsUacKcTA4cJHXha8q2m4TAAnXQaXBn0FHpX/A0qfZUD3uM2qp4Z51Ai3
	Glkf7M9ozVgfhLKVopqA6H6dNo1/knDxI/CGoZkSQmJvbLpQF3chsnTLDpJDiIcZ4Z+xhMhYmKb
	Qv6dXBkDnqPyqKCLHP0risPLbxKl4pDlOFC0BWSGiDidM4A+VgE4wbdpfP5u+rqX1ga4WFRNTwd
	7ymn0wBbayWY3VwJ80g1RONPM8eXuyFgfWN2OKp6vIDRe+5trtCbvDaoUJp+9VvQsyUIXecZZz6
	xh2V8wumWj71C7LFKs=
X-Received: by 2002:a17:90b:4b87:b0:39e:345b:3323 with SMTP id 98e67ed59e1d1-39e54fb121dmr4831022a91.22.1789732800428;
        Fri, 18 Sep 2026 05:00:00 -0700 (PDT)
Received: from kernel ([103.219.206.97])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c2876a52esm4179626eec.20.2026.09.18.04.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 04:59:59 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: clabbe@baylibre.com,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] crypto: amlogic: Fix IRQ handler return value and fallthrough logic
Date: Fri, 18 Sep 2026 17:29:50 +0530
Message-ID: <20260918115950.9121-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In meson_irq_handler(), when an interrupt matches a flow but the status
register is empty, the driver prints an error but doesn't return. It
falls through the loop and incorrectly prints an `unknown irq` message.

Fix this by returning immediately. For empty status registers, return
IRQ_NONE instead of IRQ_HANDLED to avoid masking spurious interrupts and
allow the kernel to detect interrupt storms. Also use
dev_err_ratelimited() to prevent console lockups during an interrupt
storm.

Additionally, the handler returned IRQ_HANDLED for genuinely unknown
interrupts. Return IRQ_NONE instead for unhandled interrupts.

Cc: stable@vger.kernel.org
Fixes: 48fe583fe5417 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
I have addressed the IRQ specific issues in this v3. The other
pre-exisiting issues mentioned by Sashiko are already addressed in my
separate patch.

Changes in v3:
- Revert accidental clock management changes that were squashed into v2.

Changes in v2:
- Return IRQ_NONE instead of IRQ_HANDLED when status register is empty
  to avoid masking spurious interrupts.
- Use dev_err_ratelimited() to prevent console lockups.

Link to v2: https://lore.kernel.org/all/20260918110504.7207-1-raizudeen.kerneldev@gmail.com/T/

 drivers/crypto/amlogic/amlogic-gxl-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 169c6eeb51e5..09d3ccd92b80 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -37,12 +37,13 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
 				complete(&mc->chanlist[flow].complete);
 				return IRQ_HANDLED;
 			}
-			dev_err(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", __func__, irq, flow);
+			dev_err_ratelimited(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", __func__, irq, flow);
+			return IRQ_NONE;
 		}
 	}
 
-	dev_err(mc->dev, "%s %d from unknown irq\n", __func__, irq);
-	return IRQ_HANDLED;
+	dev_err_ratelimited(mc->dev, "%s %d from unknown irq\n", __func__, irq);
+	return IRQ_NONE;
 }
 
 static struct meson_alg_template mc_algs[] = {
-- 
2.53.0

