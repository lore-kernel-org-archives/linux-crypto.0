Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E714762FF
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 04:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714105615; cv=none; b=g95YpPsF0q7RlWPkfpmur4PWvt9DUE9pRYyBAV0crEzCU87zTBMD9LKqBIVAmfTMm97+saxtAAZHmgpoa/avZjrgrLRscB6kInrgUbNpB+87WwBJqgOZBWbDpYAyEKCauMyi2FOys/p0OMXoKnFFlmUmaXqRzKvaqZt6tlpwVNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714105615; c=relaxed/simple;
	bh=2G62UbRiret+JFHldUEeLKosQdwdSSHvM2pKWSWCTBg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z1fDS02u20dN7MYAUMmAyMOSIttRb2hup1hKyTGSF47YWax40vz3RmJ823hxfIvuRFyhXpnJW4IaOTZfZKkUHBjqr8q4OQpNrb5SXEU3KSMQlgDRyDcSh5CXIU80uzCIevGKNO77z4v3bmtoiQ4+db1JSlUarpuQrHkYEvp7BwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=NF1o1fFr; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="NF1o1fFr"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5d3912c9a83so1083182a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2024 21:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1714105613; x=1714710413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5nT82FbLQ4NKVbDvBdQCptQQBdFWsfFRN8DfkDdEHCk=;
        b=NF1o1fFrkD9UrJNPL6YiLaQyl4rQtn1mAMcD8pdHro948bhtKNylkr1O++WluvMcR5
         Nycwn7dYY40f9xkqANm+tS+hbgAJeV19Rp4oWEbS7L60M7B0i2Cp7DEi2G13WbdYwdRb
         k/PYWTrYV1oB8IC+UpyaeADYTMegxGQyQ8Mvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714105613; x=1714710413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5nT82FbLQ4NKVbDvBdQCptQQBdFWsfFRN8DfkDdEHCk=;
        b=jmBV/00o7Rcq7vSs4U88MK6OGZ4ekTTM6rAwz1flAzzvHIveAuR+NiNaxMk2BQS499
         rtFHWmFgzY4AQ+srCzgBlJuBNeS4nP/uci/QGLDHeHZ8apf/jdO5yHgnAQh+vllEMNqR
         zUw9EESlLVQw4aTiJxTULBX8tkx7DH5aJ8b3fBi9gjSz0Nnd5CTKpsGQ9mT2z7TpDL2j
         vE9UBgBTyuQsbXr2ugTx5gBxNcpW36p8qZ8XILxhHNEMUk4Duws/RasDS2eyzxrvi6hp
         zHpQSE249RfPo067mWvagUh1JV4kT8i7NmeyogtDa9QZ6iwQo8PrlimsX9ANrzbKWep+
         nATg==
X-Forwarded-Encrypted: i=1; AJvYcCVNWdIuOwyda/K3G1aVIlcY71UYR9uVaHVRqRnHXF7aujBJeWnjGQ4zxYQGAzcGLFL6qHkl0Wdx6h9A/sP0FilljFuoz/TBDeaVdH/p
X-Gm-Message-State: AOJu0YwiNWZ9G/l/zIitp9PrLO1rePmzZ9OIzVAaPwcLrcG+CHwJJjb1
	tJiw5KcP5noN3+D/ZCYmvcX6bt151/hoHcv8nXjbWLphfRNYnr+4R/lB/eRXq/k=
X-Google-Smtp-Source: AGHT+IFMgpB9frPDSZOQXz/aANY/37IgyvXpb3nA1GD/A4Pb8fbaOxLLoDAs1cnLVthkBenxG3uPqA==
X-Received: by 2002:a17:90a:9c3:b0:2ad:6294:7112 with SMTP id 61-20020a17090a09c300b002ad62947112mr1711386pjo.14.1714105613535;
        Thu, 25 Apr 2024 21:26:53 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id t12-20020a17090a5d8c00b002a474e2d7d8sm15500291pji.15.2024.04.25.21.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 21:26:53 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v3 6/7] Add SPAcc node zynqmp dts
Date: Fri, 26 Apr 2024 09:55:43 +0530
Message-Id: <20240426042544.3545690-7-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
References: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index 25d20d8032305..c73559093b5b0 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -284,6 +284,16 @@ amba: axi {
 		#size-cells = <2>;
 		ranges;
 
+		spacc: spacc@400000000 {
+			compatible = "snps-dwc-spacc";
+			reg = /bits/ 64 <0x400000000 0x3FFFF>;
+			interrupts = <0 89 4>;
+			interrupt-parent = <&gic>;
+			clock-names = "ref_clk";
+			spacc_priority = <0>;
+			spacc_index = <0>;
+		};
+
 		can0: can@ff060000 {
 			compatible = "xlnx,zynq-can-1.0";
 			status = "disabled";
-- 
2.25.1

