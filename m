Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7310243ADD;
	Tue, 16 Jan 2024 00:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FdpLtcXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A341C433C7;
	Tue, 16 Jan 2024 00:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705364787;
	bh=gEqOR6WtgbGODsSv5BKZ8CiNtcUfreEdGMR8WRY4FeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdpLtcXyyA+QJIvUMNqvj6GVwhcs0iYNT1B+KHntDusWtDDENbR/l6ozu0FDTtJM1
	 NCVYOXuaRKXrC1U9aVFKVmptNjvZPFL4d0jGzNOm9kaQ+aJ8vkht2lWBrJHbacmutB
	 0s3P6XXJO/X9MLUN9G0x0Np+SwuwUY6QWfU+AjL2DUByP8MXQ/qBgSLAfetWw6IKn0
	 qqR4DttQNoNs2paU4uVmlUJo+fxG0/x5nn4KvIVkH2fKJr0W+HaCx5l/IoNKx0z8v8
	 oCsD5O/lFjBx+vWOWaUcaUusJSKj7fM2upLjOu9MuaToPuLAJprvuDMMuvAyL0W5p4
	 AMsK+Su72+deQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	bbrezillon@kernel.org,
	arno@natisbad.org,
	schalla@marvell.com,
	davem@davemloft.net,
	ndabilpuram@marvell.com,
	masahiroy@kernel.org,
	alobakin@pm.me,
	tj@kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/13] crypto: octeontx2 - Fix cptvf driver cleanup
Date: Mon, 15 Jan 2024 19:25:44 -0500
Message-ID: <20240116002603.215942-8-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240116002603.215942-1-sashal@kernel.org>
References: <20240116002603.215942-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.147
Content-Transfer-Encoding: 8bit

From: Bharat Bhushan <bbhushan2@marvell.com>

[ Upstream commit c480a421a4faf693c38e60b0fe6e554c9a3fee02 ]

This patch fixes following cleanup issues:
 - Missing instruction queue free on cleanup. This
   will lead to memory leak.
 - lfs->lfs_num is set to zero before cleanup, which
   will lead to improper cleanup.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c      | 6 ++++--
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
index c8350fcd60fa..dc0c25f0a11a 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
@@ -414,8 +414,8 @@ int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_mask, int pri,
 	return 0;
 
 free_iq:
-	otx2_cpt_free_instruction_queues(lfs);
 	cptlf_hw_cleanup(lfs);
+	otx2_cpt_free_instruction_queues(lfs);
 detach_rsrcs:
 	otx2_cpt_detach_rsrcs_msg(lfs);
 clear_lfs_num:
@@ -425,9 +425,11 @@ int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_mask, int pri,
 
 void otx2_cptlf_shutdown(struct otx2_cptlfs_info *lfs)
 {
-	lfs->lfs_num = 0;
 	/* Cleanup LFs hardware side */
 	cptlf_hw_cleanup(lfs);
+	/* Free instruction queues */
+	otx2_cpt_free_instruction_queues(lfs);
 	/* Send request to detach LFs */
 	otx2_cpt_detach_rsrcs_msg(lfs);
+	lfs->lfs_num = 0;
 }
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 3411e664cf50..73de61ebbbcf 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -249,8 +249,11 @@ static void cptvf_lf_shutdown(struct otx2_cptlfs_info *lfs)
 	otx2_cptlf_unregister_interrupts(lfs);
 	/* Cleanup LFs software side */
 	lf_sw_cleanup(lfs);
+	/* Free instruction queues */
+	otx2_cpt_free_instruction_queues(lfs);
 	/* Send request to detach LFs */
 	otx2_cpt_detach_rsrcs_msg(lfs);
+	lfs->lfs_num = 0;
 }
 
 static int cptvf_lf_init(struct otx2_cptvf_dev *cptvf)
-- 
2.43.0

