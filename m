Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DDE36495E
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 05:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778823767; cv=none; b=qzbQghJMqZpntyI2sP7/duvjQKguBmkLw5M24nAka4eOAyHvS8Fy7ro/nqJcIDcneG4q4OgdMlGzHmhlLm2hfIxpZPQghxU6B1F0g/x7xwzoc83KyC197c/FabVrpo9D45V1C4OzjxqsUJP3ANTia9n9lleBDsClsfxRKgZUiyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778823767; c=relaxed/simple;
	bh=Y73P+DS/FTU/93/7veziKipaMWdTKZWFtdrT9hZPEZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gS35EZ6j2L6dKBV6hoXpfFv1y0gva0TqgiiZoYc4xnalB6xq2sDLE65csfafdIfpi5NLSEnfvFWWyCizg6To8Oxs2xtKp64jmFr637UZ9a4sIsUIw2/eCanDahrpWXpxPutfA2ah0EGJADk5jjivrImul4pelRgsa/HT+GSMMzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h5Uqhr98; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h5Uqhr98"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82faf871346so6548886b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 22:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778823766; x=1779428566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1QMruzNzp/w/H8WMl6Rm7xeR7IZKT2QV9Y6KPDlL64Q=;
        b=h5Uqhr98A/S+sWa891n/nmnzzvr/7o+Kxt+YySgyGIP/67X2XmE6pED4cwveVgY9h4
         hMxNtNMkWN8M0HfhFnJ6Y1K0qZHZ+E85ByyTCh4Biu9psn3h8fTEyzg4JxZMlrEzNjXW
         WdEsY4brrHD1CreJVnYW+gEjohMz1F8teTntonshydl28SBQL0hQjD0Gsald4IFPn2kf
         gVnmoObBr+8R6Iis3BRWgMQlSyL9fMdMfVowozSpmg6iHw6W8oEgm1r6rUHTUpG26WFV
         3Fy/Qqiai9h6wgM/BQxmXsjeLpLogntYV34iSsbUKXgIIekGljwC564i0Mvz8AVvEsVi
         aMHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778823766; x=1779428566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1QMruzNzp/w/H8WMl6Rm7xeR7IZKT2QV9Y6KPDlL64Q=;
        b=S5s15K8V9c9+iryO4iYxTE99oNQ4wf24+FuiOg595T4cnfws8sgx3UmEHRYG7+9Hsu
         xkTIHo2i/6Cz5cjftviluA+WbHm3SKvfWazO3ZzMl6P58hm6xsAMEhPpyc8yaIsFiF1W
         i4thR48/d3Z2NyNO6bVCLgZa2IgcgpZAHqIK25pQ2+vwFSTLGAeiGTIkhZGrF3iJ8Vl0
         xQCmnkHpVoNqk44gsMaNbQ58Tc0+PefC59e/4t33YlzlxQkBQmuGIO8zqQRXQ1GbEcXR
         q6i0nxk8GzYyPkpXSnq93HzuLJVoE+QVZ5AoXeGbYr3TL0GCfAQCSvkUowiKaidWdTO4
         us1g==
X-Forwarded-Encrypted: i=1; AFNElJ+Yd6kNdl+0QTjsREP4whQuScdz/Gg3hNafkJYhD4thLN0NgY7IZbGJvMAFuP+A7eH1rUoc6f7FbCJD+bw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNzbxI3hv4FBIxsxMYrQtqJMyHO/B6rVmRv+pDXdSIBopOpZ+w
	8yvkBx6NQ4LiLejDMKlM9GNJX4N233DNJt8FBduLB17neXWO/8xo44Lt
X-Gm-Gg: Acq92OG9/Twkv4/tJkgg6PJc5ylYtGiHKBBPKVqsaMsHe1xoH/LiRBE1hBFmlJk53sM
	3Kg9PO7Acan5i7Ob/rpvykiphj7q0Wb6S8CPPoEdiMz1OZxcg14mhV1grWVcyc/HyIU0O/9fAyX
	7CosXNelF6zV+fawweDgcOCRM7/NpIXLIsLz77YCCYr21/uPyqkNhQ3u672g1v0jdSJQz7uRgIs
	04GTVFJfgv1QzzQbfzXhZkgpi4Go4Cc+D3Qecv0K+MwEvSIqT5n731pzoy6LkpiLSLo6z6iCiOL
	W8Ca30XIwCtGxf4CwKPQNxThTtieybPsjK3z7h6r3TTIum2LptdRCzbdcD/IEi/DcfXCKpUcZR6
	eMi4DvqOEX9TN25pyY6oAQ98iwu31wcXh7yMyg3ltLC8YLmV/Ye4LFHfpszmxWiDcVKAnytn63o
	3W2VcE4AYfmN4xxVcGy5YTWZFmRstFj7e9q+GOw6y3oMjhcn1dD71HIQU034vt2SvrJ+ftFaKSG
	zBLsammoiC5rK60MeETDy1u8Rs=
X-Received: by 2002:a05:6a00:340c:b0:82c:6b46:271d with SMTP id d2e1a72fcca58-83f33d0a2e5mr2772793b3a.48.1778823765596;
        Thu, 14 May 2026 22:42:45 -0700 (PDT)
Received: from harrison-Surface-Pro-12in-1st-Ed-with-Snapdragon.wework.com ([203.117.161.34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f2b9bec8fsm3106116b3a.33.2026.05.14.22.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 22:42:45 -0700 (PDT)
From: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
To: andersson@kernel.org,
	konradybcio@kernel.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	neil.armstrong@linaro.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	jikos@kernel.org,
	bentiss@kernel.org,
	luzmaximilian@gmail.com,
	hansg@kernel.org,
	ilpo.jarvinen@linux.intel.com
Cc: Douglas Anderson <dianders@chromium.org>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-input@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH v2 3/7] platform/surface: SAM: Add support for Surface Pro 12in
Date: Fri, 15 May 2026 15:41:48 +1000
Message-ID: <ab458aadea651396d9ea7629419a32dc7510c593.1778822464.git.harrison.vanderbyl@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778822464.git.harrison.vanderbyl@gmail.com>
References: <cover.1778822464.git.harrison.vanderbyl@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a SAM client device node group and registry entry for the
Microsoft Surface Pro, 12-inch with Snapdragon.

This set enables the use of the following devices.
1: cover keyboard
2: cover touchpad
3: pen stash events.

The battery info and charger info devices have been
purposefully omitted as they are also reported by
other drivers and cause conflicts.

Signed-off-by: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
---
 .../surface/surface_aggregator_registry.c         | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 0599d5adf02e..884049961415 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -422,6 +422,19 @@ static const struct software_node *ssam_node_group_sp11[] = {
 	NULL,
 };
 
+/* Devices for Surface Pro 12" first edition (ARM/QCOM) */
+static const struct software_node *ssam_node_group_sp12in[] = {
+	&ssam_node_root,
+	&ssam_node_hub_kip,
+	&ssam_node_tmp_sensors,
+	&ssam_node_hid_kip_keyboard,
+	&ssam_node_hid_sam_penstash,
+	&ssam_node_hid_kip_touchpad,
+	&ssam_node_hid_kip_fwupd,
+	&ssam_node_pos_tablet_switch,
+	NULL,
+};
+
 /* -- SSAM platform/meta-hub driver. ---------------------------------------- */
 
 static const struct acpi_device_id ssam_platform_hub_acpi_match[] = {
@@ -500,6 +513,8 @@ static const struct of_device_id ssam_platform_hub_of_match[] __maybe_unused = {
 	{ .compatible = "microsoft,arcata", (void *)ssam_node_group_sp9_5g },
 	/* Surface Pro 11 (ARM/QCOM) */
 	{ .compatible = "microsoft,denali", (void *)ssam_node_group_sp11 },
+	/* Surface Pro 12in First Edition (ARM/QCOM) */
+	{ .compatible = "microsoft,surface-pro-12in", (void *)ssam_node_group_sp12in },
 	/* Surface Laptop 7 */
 	{ .compatible = "microsoft,romulus13", (void *)ssam_node_group_sl7 },
 	{ .compatible = "microsoft,romulus15", (void *)ssam_node_group_sl7 },
-- 
2.53.0

