Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245AA1E47B6;
	Thu, 19 Dec 2024 08:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734596089; cv=none; b=sg0MWSuiAjmho7umPXX6u2vKpxr/emv713YdfnzBND0BDo8p0CumF+pvuxbDeqdyx1n1dXzTW3+9M9fx/YSev2E/uaVbLvyCWvMt7Ao1PkO8a1JejqiR4/mENHxiPFGePpGAuO+JesbcoUqiAG8XhAHwUyqgy/Dz29WGA4hPzjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734596089; c=relaxed/simple;
	bh=0kvCy8gOMJvihmCmWwF/KYzUPSpz8HWf1k4W/UIl7PM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TAKRUEtaxGzJl1KsY9KsABG0qbInhpqQXkK84/CxvYOLb5aWrR3b+aH9HlbkAmVzqfW0/FJO4UIhOVf6YLc4MqojJdBq8hc7irSG7ORWdqdCz3oous8VXSCfaQAyfRqXbs1ukA3xfxA+bGhCqNOvZBSfzFZjHfNwP9EeE36fc00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=hGRjpzbV; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="hGRjpzbV"
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:b1cb:0:640:2a1e:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 1B3A560A89;
	Thu, 19 Dec 2024 11:12:52 +0300 (MSK)
Received: from den-plotnikov-n.yandex-team.ru (unknown [2a02:6b8:b081:7212::1:2c])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id LCNib32IeqM0-YwyFNNEa;
	Thu, 19 Dec 2024 11:12:51 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1734595971;
	bh=cCjJK/VDvZMVPLkNJF5eVbXTCNBDUUBmZ7KoutTR+vA=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=hGRjpzbV31CufaIQys7SQ2RoLjIVgKPugwlwUHjqPs5rw62BYZkI1Ntlwepe16o3S
	 1BCkl7YKL2j/nEgJZxZJnTOYMugO1YU3OtnIVMEG+4e6uFzDtBS2vnOgNL/K8HSeNE
	 O19DiJ2OYM9X44kW5sGwrpbusDWnyH/BJnVTPXF8=
Authentication-Results: mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Denis Plotnikov <den-plotnikov@yandex-team.ru>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	john.allen@amd.com,
	thomas.lendacky@amd.com
Subject: [PATCH v1] drivers/crypto/ccp: change signature of sp_init()
Date: Thu, 19 Dec 2024 11:12:21 +0300
Message-Id: <20241219081221.702806-1-den-plotnikov@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It always returns 0 so make it void instead of int.

Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
---
 drivers/crypto/ccp/sp-dev.c      | 3 +--
 drivers/crypto/ccp/sp-dev.h      | 2 +-
 drivers/crypto/ccp/sp-pci.c      | 4 +---
 drivers/crypto/ccp/sp-platform.c | 4 +---
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index 7eb3e46682860..bd6800dc190ca 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -188,7 +188,7 @@ struct sp_device *sp_alloc_struct(struct device *dev)
 	return sp;
 }
 
-int sp_init(struct sp_device *sp)
+void sp_init(struct sp_device *sp)
 {
 	sp_add_device(sp);
 
@@ -197,7 +197,6 @@ int sp_init(struct sp_device *sp)
 
 	if (sp->dev_vdata->psp_vdata)
 		psp_dev_init(sp);
-	return 0;
 }
 
 void sp_destroy(struct sp_device *sp)
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 6f9d7063257d7..89146a41a228d 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -136,7 +136,7 @@ void sp_platform_exit(void);
 
 struct sp_device *sp_alloc_struct(struct device *dev);
 
-int sp_init(struct sp_device *sp);
+void sp_init(struct sp_device *sp);
 void sp_destroy(struct sp_device *sp);
 
 int sp_suspend(struct sp_device *sp);
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 248d98fd8c48d..60ae129997481 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -299,9 +299,7 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	dev_set_drvdata(dev, sp);
 
-	ret = sp_init(sp);
-	if (ret)
-		goto free_irqs;
+	sp_init(sp);
 
 	return 0;
 
diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
index 3933cac1694d4..5abe531edb48c 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -161,9 +161,7 @@ static int sp_platform_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, sp);
 
-	ret = sp_init(sp);
-	if (ret)
-		goto e_err;
+	sp_init(sp);
 
 	dev_notice(dev, "enabled\n");
 
-- 
2.34.1

