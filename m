Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CDA72617;
	Tue, 16 Jun 2026 00:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781571168; cv=none; b=qOiBYwyBeBhFsZcEWwdGa9yDvDQPAVF5EW8AxBGe5ylhmHUDqLgYG9v+jp0QLEVO9ABXKstbpSIsYJZAuLNZyobD4ZG6zhA1PQb5/PtV0vLMqKmvjcP3VgA684861Hin8OPDUYSR8mtKtjkZmyFs5nb8RB3t1hkIHK7n3Ue+tzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781571168; c=relaxed/simple;
	bh=qRg10UkwmyevINV4nx/M0CQh+B3iS8+qs/L8vXhSt5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Anl1b08v10Wqb/AhmtbsGyVKEJkfLlqUVc5QduTJUBthkvecsg/fgHHehrA3yghaAV8hl2XFQd25Npk6BpG42x3kccsdpwdTwEG39cT8kpp4hSVSXxets60Yzj+O8nUPDT504heQ9jjDII8joaXYAvnzwu3FoZA15TJBcUH7PJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-03 (Coremail) with SMTP id rQCowAA3HONYnjBqX6HeFA--.5311S2;
	Tue, 16 Jun 2026 08:52:40 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] crypto: caam: depopulate job rings on populate failure
Date: Tue, 16 Jun 2026 08:52:39 +0800
Message-ID: <20260616005239.6655-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAA3HONYnjBqX6HeFA--.5311S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKFyrZr48Ww18Gr1ftry7ZFb_yoWDCrb_uw
	1FgFs7Cr1fKws29F48tFyavryFva93XF48GryUtrsIqFyUXrsrWFn7ZrnxCF15Zr42gr9I
	g3WDtw4IkryfujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUY9a9DU
	UUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

devm_of_platform_populate() only registers its automatic cleanup action
after child population succeeds.  If CAAM job-ring population fails after
creating some job-ring devices, the probe error path reports the error
but leaves the partial children registered.

Explicitly depopulate the job-ring children on the populate failure path.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/crypto/caam/ctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 320be5d77737..716c57b9f89b 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -1150,8 +1150,10 @@ static int caam_probe(struct platform_device *pdev)
 		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
 
 	ret = devm_of_platform_populate(dev);
-	if (ret)
+	if (ret) {
 		dev_err(dev, "JR platform devices creation error\n");
+		of_platform_depopulate(dev);
+	}
 
 	return ret;
 }
-- 
2.50.1 (Apple Git-155)

