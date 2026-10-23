Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792766923;
	b=Ah/w14p89ax9aJDRDnxce4JGw8VLHyjjf1YwPm3IQV4W0EIYAnHjkhed7oLWTxemQBy4
	 HETkW58srMq3BhDiU9Q7YL5Kfy/pEANusyoPfUr+XbPtDaj8hIHduTJ8KASq1LXhl5FbO
	 L5ZJNWtNhd60Uxqnbibc2UJnGHEseRnWo0fV051FByYCVAvIUFJghVp1nt0dyZEO7iumY
	 l6yCJjAIUmmexTZ+X5bHHdtmLfpcC5cRJbAuZa9gRCgETkHGDcJX1uhn8q8D8rR5piBPt
	 7jK9HucVPfMesOKiDMPRE1TveAYCpiIWNQtt6oFqDuGBW3B3IOUtFPK5XeEwj6dkSuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792766923;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Organization:Content-Transfer-Encoding;
	bh=qHVaCrbZVV/aL8obwXxHOaq/3zcOfPB+i++209LsGG8=;
	b=2Fga6MX95Gd8ihYcCNvH6Foy+c7jUxSOUPxy0PvAJfPMUmS3wf3jzGtWlVDufzOi55Li
	 n2WGh4mHtjU1w5KrDVEYDQSq5F1fZFCKlR4nwKUWNgBLySbD13ajkUbzcfNDwhVdOhzFT
	 yYCtSUU3cn7OZKl6+so95KszLQgMfX9IRQeDr6kEevw1RyYrrbrUz38eeU+ebgzH6C8ys
	 ahUCe6Wzw62gjXhR/dKK8jjtDMhgJ0ywcMcYeqCiKAGwxVO7LjgWAj/GDjUYqg6LTI0vG
	 TSAF6eV4PpwjVWgM+yzqLTAyHFsHdj+eWeZGyTBtq3upYSwPcVBkXWUWs+obrjCMumA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gvTiYJrT;
	arc=none smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0314C606A32C
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 14:48:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0314C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gvTiYJrT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792766922; x=1824302922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hgamFFdtwFhF7P0xfkrYYUXesUQtJNAznKhQkw8jUU4=;
  b=gvTiYJrTwaBe/WaD5fRZSlXZJaoMd6+AvYIH16WwSSh+YDKcBEXbQyzq
   M+ks6zDSBxKIaJEvVYhpXSDJCa3Hf1iO5sVv5KO/NJazXeY6+wmDUqQ/m
   oaSOmM2bSlX6mNwAC1LutgP1Tp4+ldk/mmLxwUYrqESjy2aeAnRZ/UgSE
   DBZj2z5lpkY4YamJmqsnzS8qWqSGAK4h/No7jJBjWooSbU9So2LqC+tRo
   vsQMvFGoUgGm2n0uGOj6qvFveFnVfWSOevpCEJLTmdJKFKmg3kmAp1kxX
   jkpDbJnox+tDipEM3dkiT8sXd8ZN6Q92bMQX18gOGk749NqyJ0eeSYYZy
   Q==;
X-CSE-ConnectionGUID: OLNYJaFRQNK++kHlct+7CQ==
X-CSE-MsgGUID: l/GQd1fUR0WmDzQOdeNT1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1534182"
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="1534182"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 07:48:42 -0700
X-CSE-ConnectionGUID: +Fz3ugsNQoixDXXqgI1/1A==
X-CSE-MsgGUID: nmWhwNjiRZm7A8ZGYN6FVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="3598361"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa005.jf.intel.com with ESMTP; 23 Oct 2026 07:48:41 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH RESEND 2/2] Documentation: qat: document three-service mode for QAT GEN5 devices
Date: Fri, 23 Oct 2026 15:48:35 +0100
Message-ID: <20261023144835.170453-3-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261023144835.170453-1-ahsan.atta@intel.com>
References: <20261023144835.170453-1-ahsan.atta@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Bairavi Alagappan <bairavix.alagappan@intel.com>

Update the cfg_services sysfs attribute documentation to describe
support for concurrent symmetric crypto, asymmetric crypto, and
compression services on QAT GEN5 devices.

Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
index b0561b9fc4eb..48e17de3e0fd 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat
+++ b/Documentation/ABI/testing/sysfs-driver-qat
@@ -41,8 +41,8 @@ Description:	(RW) Reports the current configuration of the QAT device.
 
 		Service combinations are permitted for all services except dcc.
 		On QAT GEN4 devices (qat_4xxx driver) a maximum of two services can be
-		combined and on QAT GEN6 devices (qat_6xxx driver ) a maximum of three
-		services can be combined.
+		combined. On QAT GEN5 devices (qat_420xx driver) and GEN6 devices
+		(qat_6xxx driver) a maximum of three services can be combined.
 		The order of services is not significant. For instance, sym;asym is
 		functionally equivalent to asym;sym.
 
-- 
2.50.1

