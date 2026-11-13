Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.254.200.128
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552936;
	b=gn8CcN5vgxKag8r14+q2akYsqqeJD5/QdiluYYM7hkFNwBcOyZlJHbARqZv3uli8Z4Cz
	 aFVqKL5/n1dH1xpP1sBTnGcwXerofPu6B4nh+rzXWtYhfVIzdMMuQ49x/tGszfXkVFObo
	 TZg9yN/8dCQZ4rWb3BbrdB5A44YvdLxFrNWLyCm3db9CaziiVXpFJEN6469PCMZAtc5bJ
	 ITMU5E6VRF62dTY4aXIhwZw+ZkqEmrtzF6+ZDguNqSObXgC0ydHiHNgnG4HuecPbPMtHn
	 Wwx/Vv1ti1WJitaIxzHgCET2O34ERmeSORweN+E3GKLtFioNgWcb/VaadUXMj28xB0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552936;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:Subject:
	 Date:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-QQ-SENDSIZE:Feedback-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=zkvrBkQkORv1dN69+eugusOL/HOyyiE7O6cE6sFTrpU=;
	b=uJPqzUEFN/4ew6w2fCe/dqicOEmerAqAnpT7w0jAx8QvxFZZOJy5jCmDM2dxrZ7I7kBn
	 iMUsfE85ztkdp2a5Z/n6IJaYgnr8nu/jb0nkFrTiSsBtSyf9JISBGsFQcVYPrHw9va9Km
	 vtKVOeNYFQbKI/9pNGwuNMnAZnQWbjJBLvJZmmV7z5J+j6/zuUYbyJu6b0OMd3wsMH3La
	 1NL7nZ9IS49eCfhNDZSmjluVUArAjIjH5Kjf1Xg7jB5Lilu3WDu30kFcuajXDTPe4UABb
	 x5m/bP/5jA7Lj7+ICBRfQvX5CLlKM96YuWypFhGDrdroMcRUkts1jY/t4Dnf5D3JF7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=V1jt0ub1;
	arc=none smtp.remote-ip=54.254.200.128
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D68606A898;
	Fri, 13 Nov 2026 06:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66D68606A898
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=V1jt0ub1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1794552893;
	bh=zkvrBkQkORv1dN69+eugusOL/HOyyiE7O6cE6sFTrpU=;
	h=From:Subject:Date:Message-Id:MIME-Version:To;
	b=V1jt0ub1SxzXdzput7UcCfwNIRikynnHNBpjvyeceQ6osWgsxdgw4xY9SbI7pfDdS
	 Wx0QHtPKBaW3xDqTODPDTt1vOaQjoFsLHxZ64ypYJa3OkSQlq5W37bwoCySQhWC+eM
	 W8XZ+fXFozeDysrlw1UINDpUreGRc87ZrklsEfgI=
X-QQ-mid: zesmtpsz3t1794552876tab0d23cb
X-QQ-Originating-IP: d7Asjst459ta+Kd1IDKMbE43ahhKTv/GNdlgTwIl3zc=
Received: from [10.10.7.69] ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 13 Nov 2026 14:54:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4825511718074901745
EX-QQ-RecipientCnt: 11
From: ZhaoJinming <zhaojinming@uniontech.com>
Subject: [PATCH v2 0/7] crypto: qce - fix CCM AAD buffer leak and AEAD
 error-path bugs
Date: Fri, 13 Nov 2026 14:54:18 +0800
Message-Id: <20261113-fix-qce-ccm-adata-leak-v2-0-914501377a62@uniontech.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABq09moC/3WOQQ6CMBBFr0K6dkynAhpX3sOwGMpUqlK0LURDu
 LsF49LlS978N5MI7C0Hccwm4Xm0wfYugdpkQrfkLgy2SSyUVCVKLMDYFzw1g9YdUEOR4M50A2S
 zyw3uVU0o0vHDczLX4XP15TDUV9ZxWVuM1obY+/daHnHxfpHyX2REkGCKnA6KjGpYngaX/o2s2
 63uO1HN8/wBUPIfLtIAAAA=
X-Change-ID: 20261015-fix-qce-ccm-adata-leak-1ef34f172ba1
To: Bartosz Golaszewski <brgl@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Thara Gopinath <thara.gopinath@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, ZhaoJinming <zhaojinming@uniontech.com>, 
 Eric Biggers <ebiggers@kernel.org>, 
 Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OTUHZG7Ulf3m2vwH0bHApknKcCyS1pwjH0iLVMwoGRwvS0GFOPv5ENng
	l2/4LuHLIgcTqiP1N1l5cU6NranX0fwTqndMuBOQrkJ1YnvdXnvQPcleoDSF+pG9ZDZmlgR
	zXkoetNrYE68nIl9zf4bteBnusCK+tKUZe9TGP76iYffsPq7Ttv2x0JNP8y24DWKHxDMNFz
	+nzOTehgSN4x1wXpC7334rccsQiM4Jsej8u5n8tS2qOYHTRMtavNP2YPKACvQg5kAX24UQE
	Hr/VusX9WacGDO8G5H4WnzzGoqXZ3DFI3rFiGB8a5JnIZGWsxniyNExH8VazMuV/KisUk+d
	igF3MFwPAPBgFmD/PPBkcl10jnlpNHEu9sFk1ujOJQ4MAOrOTA/m85D1OZAjsGUjh1NBzBM
	r18shesphz6dZjL298Q3xBMpRL3LkdlDp6HtYNGsTSeJYZtird/Z0U+H5iDUAA+eABns/2A
	PGysoTihqjEG0FUXdsOAsokXiOoSqpEm/4OCKrlMIq4pSGDd0AtHdUEp0ul7JL0se1Q8dR6
	Q8rY3iPzpR2npTBQoR1ybczAhM8sw28+BoO2C8gLVCAhCT/AeK0EmCx5b0Gcgm+II5qNQxd
	SEvjVXUCp6bLTuwxJfSQQepEAS8Kb7i4jrx7i0PLmf5WbcxG/HUVIr3D3+Zzo15y4H2Zqii
	up6NUhGWI+G0r8wv/qtUGBD0wcWQr4av7UWvdHZmvZ7v7Cwg/o5jiU4kPjTCBDrNUOt7nis
	gQm7w8/j6Ll+r9vtUmMPJF+i7mMCEr0aMhJ4kJjcPQQBknMs+TTZq4xcQlsncs5VRnVHlsz
	3c+TjMf9C66PsEC1N1L81nTtO9W6N5woqiDK70FEfo1Q2XuYubJr5fxbUkAZ3QAvcYW3mWD
	bSFRc+h01Z+gFIwklgAqNq/JW1FsNkSoIC4CijAZWdLb8cFPYwfMNpgkm4GuqEQYTbeRiC2
	MAzZjPEQrFbm7X9kwXaXRdsbeyw5eCRna6EF7zgeFOS5kgydlL3s0nZ14DWI1+kodq26okx
	6lzq/MPH4vyB1fU/l21pIPK+/+NVbblUJUQJO63RAkr10NTr5U
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

This series fixes a memory leak in the QCE AEAD driver together with
several bugs in the error handling around it.

qce_aead_ccm_prepare_buf_assoclen() allocates rctx->adata for every CCM
request that carries associated data, but the buffer is never freed.

While preparing that fix, a number of problems in the error paths turned
out to matter:

  - qce_aead_async_req_handle() unmaps req->src although rctx->src_sg is
    the scatterlist that was passed to dma_map_sg().  For CCM requests
    with associated data, rctx->src_sg carries the AAD buffer, so its
    mapping is leaked, and freeing rctx->adata there would free memory
    that is still DMA-mapped.

  - A dma_map_sg() failure for the source scatterlist is not detected,
    because the result is checked for a negative value while
    dma_map_sg() returns 0 on failure.  The error path then unmaps a
    scatterlist that was never mapped.

  - The error path frees rctx->dst_tbl even for in-place CCM decryption
    without associated data, where that table was never allocated.

  - qce_dma_prep_sgs() may leave a submitted RX descriptor behind when
    preparing the TX descriptor fails, and the error path does not
    terminate the channels before the buffers are unmapped.

  - sg_nents_for_len() failures in the CCM AAD preparation are not
    checked, so a negative count can be turned into an enormous
    sg_alloc_table() request.

  - qce_aead_prepare_buf() leaks rctx->dst_tbl when the source
    scatterlist is shorter than the requested length, because it returns
    the error after that table has already been allocated.

Patch 1 unmaps the correct scatterlist, patch 2 adds the missing frees,
patch 3 fixes the dma_map_sg() check, patch 4 guards the dst_tbl free,
patch 5 terminates the DMA channels on prepare failure, patch 6 checks
the scatterlist count and patch 7 releases dst_tbl when the source
scatterlist is invalid.

The first three issues were reported by Eric Biggers in July 2026 and
later flagged as pre-existing by the Sashiko review of the QCE BAM
locking series.  Patches 4-7 address further pre-existing issues found in
the review of this series.  They touch the same function that was
recently fixed by commit 7f2345f47dd1 ("crypto: qce - fix CCM AAD buffer
underallocation").

The DMA API issue in qce_ahash_async_req_handle() in
drivers/crypto/qce/sha.c, reported by the same Sashiko review, is
unrelated to these AEAD paths and will be submitted separately.

Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
Changes in v2:
- guard the uninitialized dst_tbl free on the error path
- terminate the DMA channels when descriptor preparation fails
- reject a negative scatterlist count in CCM AAD preparation
- release dst_tbl when the source scatterlist is invalid
- add Reported-by and Link for Eric Biggers' original report
- carry Bartosz Golaszewski's Reviewed-by from v1
- the sha.c DMA API fix will be submitted separately
- Link to v1: https://patch.msgid.link/20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0@uniontech.com

---
ZhaoJinming (7):
      crypto: qce - unmap the correct scatterlist in the CCM error path
      crypto: qce - fix memory leak of the CCM AAD buffer
      crypto: qce - check dma_map_sg() result for the source scatterlist
      crypto: qce - do not free an uninitialized dst_tbl on the error path
      crypto: qce - terminate the DMA channels if descriptor preparation fails
      crypto: qce - reject a negative scatterlist count in CCM AAD preparation
      crypto: qce - release dst_tbl when the source scatterlist is invalid

 drivers/crypto/qce/aead.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)
---
base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
change-id: 20261015-fix-qce-ccm-adata-leak-1ef34f172ba1

Best regards,
--  
ZhaoJinming <zhaojinming@uniontech.com>

