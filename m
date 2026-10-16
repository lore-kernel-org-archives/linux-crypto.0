Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997133148B4
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792160634; cv=none; b=QZSYVKrUUfid4QkjGWjmTm3J+xea2FAIaJD/9jXHBbbcIFmmSM76Eev1DHqVdya0pVGIREawa5VF3BUEzbDzrtOnI0WO4SS7p/U4FKoSJjJ+ubTiwZsm3rYLDAzoReChCyN/cADF8w1FFWr970WLj+66DO+w9E4zwyoGNpk91UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792160634; c=relaxed/simple;
	bh=MI7aGsAhowjrn0G1dvx4rWoW+SP//6UECXLSEzUGEUY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=rS5Y6GIsPrt0dWgscZyzWHSfXFCOyGsFoiBBpt5Vb2+0sPOvN3f6KzsJicZ+QyotluM0mXsj7a7d+Wcv18K3/kQHpHaYl7G0KUIcVzbEh940BBXY/In+PVPwwXIvBM99g84EZiftsILyEknQ8tdgfR96zg6gquIYJLa0+A8KhEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NUX4BaD4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cqYiSLWf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NUX4BaD4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cqYiSLWf"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE5xhr2914869
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:23:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=QAV6QvbzCrRNJrfQ0PB5s7
	+nbUsq091tRlQY9ZJCqpM=; b=NUX4BaD4fJIdgyn0PeSeg/Dp80htxGoz0PiMow
	3Y2mTo7xhwqtUwh6xrFewByzLe38vNt6lBKJ6G8n223QBRxCHuSCE9oemw/g5vl6
	J3gzCXsBzK2hwUYFwkV1RJtPK/7UXklRykhG39zhS9Dsnp3WEUKDSHX+L/t1PfCD
	m6DiUfojLNXMs3r4TiEZAwsoVQ4q034g+dONn0A8bU5ICPEHS0pAkNa0jBAFxWnT
	iZVaNIYFl0HLIURtz1y0i5wdfB/bxFsikxDuB4ZPCo1iBj+nuDtrQ+57d13dKJK/
	3eMpYdAKTCOupVn9idtjTdJce5nIdIa0uiaE48ewewQM/m5A==
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com [209.85.222.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbmmq08jy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:23:51 +0000 (GMT)
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-98a9c848bf0so2688241.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 07:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792160631; x=1792765431; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QAV6QvbzCrRNJrfQ0PB5s7+nbUsq091tRlQY9ZJCqpM=;
        b=cqYiSLWfFHDBR2HYk2sVFU8qOF9n2i5N614oOrEIt9TxfIicyxVVw6G+OLHJesho9O
         OI7ZZLNyiECnGyLxZmCvYcRXnt8yC9iCO2vnZN6ZXeRwyLG2ts/GdJLL20h1BQ6V3GCB
         Uo3N0etC/7lo32wfAE9qtqyC/l/4qVb9RyhcoCBzp/QZdOSMqDu5dnkMEtqtaSK6qWm4
         yUgVsS2OedQxm/lTOPmJGlkErWDi1+7jHg9go/UcaQvEGfL8Bjxv4esHYdOlNyMTBY/O
         H5Yh01Z1R+328oxzW7T8tWnVy4a1b3M3gqXVk5GD3Xe+ds/MUVOdqQfXPenSOklJWpeP
         0ztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792160631; x=1792765431;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QAV6QvbzCrRNJrfQ0PB5s7+nbUsq091tRlQY9ZJCqpM=;
        b=f7MkWTNjaORL7zSb9PPma6frmWB+4TvhKKWOTM5AUIREciatxJ+U8tObQsikSRIXdW
         PxAwW93uaW2R+ODxNhKLc/Z9aIH8cvqAYGwmtq7+P86M5UJkJmeD2EgIwZLBT5FM7fuJ
         yjVtgjgY4eiO8/tmKgaV/ius2/S32fQ2sw5YSLlTIu/lb1qCujA+5HND3KxvdZEZV/yZ
         ktHSyQjSyBJCpoWhclZAwa+rHbZN+a17U7CGgYSLJ3BeXs8/2ymhbl2SrexCfyhhw48k
         IcBlpRz32NJedmWTa16hXSgNZJmpap02Y+RNvPfWDBJEtICOXI/9pukoyjW23qNtcwXp
         HQGA==
X-Gm-Message-State: AFq9FYJoqYhNtkDTv663qf/wsaDic0vtNqzYDv+EHNZcFmNIpSLzL3Ow
	GTo4rz3ZtlR/PRmIV/lGEiCYqDA8XOrAjowWLE1hAD9T5lXjkIg0wTO0OXst2X7+GWdRG3QepEW
	1zBcJ5CTgcfSMeQfeImtf136KhqhOvCY4P02oKnUl1XJxH8HMosKpw3GobPenq2HKq8c=
X-Gm-Gg: AYBFou2rNPCPtqy3U0kSG2bnnltP9hrsaaEfOnF7BMDh6/bH/XNT8XUtc1ggP8s9/jY
	0mWzSwRRXyEPTbvLaVZwZxHo9QE2FUTOQUhSAaBGFKEVAdZwEwuwtx2CHgZhxWBgz+R6MR7Fxa8
	2wdrBkES24kWRKISvtf5HXHP+W36qtmIIFk1IUFmtF3T/p9i1Eaw1K3572raVQCGXPeF51W52IG
	hCyyUT62BL6e0JeArmaSdyMIVDuvA5T44Ww5tAAo286uSrt35682+MqA0g5qW2Eo30sqNEX6JeL
	8TlVI1B+ElBNKHUHtwTHC4TfbZCqC3DKqD6qzsMtF/otz0M3YY0MFkj5oMassunVP8pX6A9Y1Rm
	cVxlBgdff1h9WZ0EMtMPtdLPuz5Zb
X-Received: by 2002:a05:6122:620a:b0:5bf:b3a0:388c with SMTP id 71dfb90a1353d-5eaaa415093mr83392e0c.6.1792160630461;
        Fri, 16 Oct 2026 07:23:50 -0700 (PDT)
X-Received: by 2002:a05:6122:620a:b0:5bf:b3a0:388c with SMTP id 71dfb90a1353d-5eaaa415093mr83342e0c.6.1792160629657;
        Fri, 16 Oct 2026 07:23:49 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4c0894sm4997268f8f.12.2026.10.16.07.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:23:48 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 16:23:43 +0200
Subject: [PATCH] crypto: qce - Fix HMAC self-test failures for empty
 messages
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-qce-fixes-sha-v1-1-3ee5a30d84f3@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAG4z0moC/x3LQQqAIBBA0avIrBtQA4WuEi3MppyNlQMRiHdPW
 j4+v4JQYRKYVIVCDwufucMMCmIK+SDkrRusts5o4/COhDu/JCgpYNBmHW30nqKG/lyF/tiXeWn
 tA8fLNL1fAAAA
X-Change-ID: 20261016-qce-fixes-sha-a01b32c77ec0
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=9147;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=MI7aGsAhowjrn0G1dvx4rWoW+SP//6UECXLSEzUGEUY=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq0jNzaDwucIbeYe8QPAZx0qspd75lcpPeJevgd
 ttSZFGjIvGJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatIzcwAKCRAFnS7L/zaE
 w/eBD/4kg8w+tZXyEiN0orLCsJDutYGlVUQCPwXJxJOrUnXtjVQ15N8O6yfe+/MwNaG87dNGTGS
 CgpHW8xBns4qljlw2GxjwOafyogguDnEdDj79iaDV3BYOj6qfxEWoHG0Sn5cSLwqix4hdWBD/W+
 u0COJaRXCMG8VkVCkObdq79iawyA0nNPIb7JvSjB/yh4lRF+LZrGRC2oFqubNgR2f/TI6By1OjU
 HM2K+6o7qodgt8g9xIR87DteIb0r3QkPFVxhDrk7Q3kNbg/JHewKcBVTskwUw2bBs5JiF02gwBE
 IcglMNO2VJNg+W2/9pNZ23WA273u0YLTJ6LW7fVZbtIBbhIeLS0N5E8O/T6s4iX63JkDuv0dy1k
 LoFlUgKFeYrJpqKRQass40IY8r8W1rEQXdpKaodCsdYoC5gY5GmVHvwW7Qs4m+gH13Fqpxe8jHw
 a1WAl1Q6t5Hu+3sVYPY/qERHNDxh/ufca8jIcVJTcUNH5CO9ZgKGVu+Q0Gg7InGW1iKkaJrrNxE
 yt0uKnAge1/xUH2I49GXrClXBXcjuiaYgjL4tJ+p6OK1cOAHpqi0xUW7tZPB0pqmlXgQt6Tub0T
 hIYCFbktNSYSewVF7kV+9zr6gA3caoeQKe2xaYS0Su6hwZSozcwtfsZK4WCuLRqfEm/qfYNnO1t
 h7fruiTQyhvrv9g==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1NyBTYWx0ZWRfXy9cjJgD8uBU3
 cZb1M9dn0GOMtLhRn+K/y/DQeT3nxFoDgjsP/U7Q0ynP0zbM6hH39riPiegDvoMhFaE7Fotq3rC
 fgKAOyZZ81MCXMp3u15Dckd/DZAULbc=
X-Authority-Analysis: v=2.4 cv=P9uvFSAu c=1 sm=1 tr=0 ts=6ad23377 cx=c_pps
 a=R6oCqFB+Yf/t2GF8e0/dFg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=wfet7WdA8w35qk0-omcA:9 a=QEXdDO2ut3YA:10
 a=TD8TdBvy0hsOASGTdmB-:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1NyBTYWx0ZWRfX6ScT8c7L7P2e
 2pZ+crkNEKXAnE6jvp+K8Ga6Z3JLMWIMji4VHxO1z/CZsZy6l/AejO/d4CtK+bKIJ+X525bGZD6
 KEF81YD9F1oPbrkje+o6wFnkhQXpvqWe37e+Oh0fH+UXZsR4cpQebX4sfMyh10ExfNmgc0Q7Bzm
 ilsWvR4mmOlBRDutWtt2IYYjFpWLPrPEo9Ef916AwcTL37jpVfBn3rweTUGHQUclokEv4hA34eL
 i2H5k2Jrb2cVKANRi+mGc6Ww6D85OdbllXuyzcfwEBcK3ipy77G6ED7sXdeJB/rgusU5fU1oh9A
 Eca/5nn2tJoxnvXk01NnSRUMd2m3gFnDMRE9nxjRi/ETHQW4x7R0e72rUIqmzwrRstofwmPzs6t
 yR9+jZr1SGmzElFTy/lJfO9OK7iHmLScLtDggsOdWXd/W/UKABdFUH30AWO39u/HYrFrBWdb34i
 ULx3ggI3Zpj0yc+jKTA==
X-Proofpoint-GUID: mwE5GD6XxmiFIX5UOKZGjV9-1QJ-xuZm
X-Proofpoint-ORIG-GUID: mwE5GD6XxmiFIX5UOKZGjV9-1QJ-xuZm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160057

BAM DMA cannot process zero-length transfers, so the driver always holds
back at least one byte to submit to the engine and only ever finalizes
with an empty buffer when nothing is left to submit. For plain hashes
this was handled by returning the precomputed hash of the empty message
(tmpl->hash_zero), but HMAC's result depends on the key and cannot be
constant, so hmac(sha256) produced an incorrect digest for an empty
message and the crypto self-tests failed.

A zero pending buffer at finalization time does not necessarily mean the
message itself is empty, though: the caller can also reach it by
importing a state that already reflects some hashed data with nothing
currently buffered (crypto_ahash_import() followed directly by
finalization). Special-casing only a genuinely empty message would
silently compute the wrong result for an imported state in that
scenario.

Handle every zero-length finalization consistently through the software
fallback ahash instead. When nothing has been processed yet, let the
fallback compute the result from scratch using the key already propagated
to it via setkey(). Otherwise, reconstruct the fallback's running hash
state from the state kept by the driver and finalize from there,
accounting for the HMAC ipad block that the engine absorbs internally and
that never goes through update().

Cc: stable@vger.kernel.org
Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
As requested by Herbert: I've split the large series fixing self tests
into smaller chunks for easier review.
---
Changes in v12:
- Split out the SHA patch into its own submission
- Link to v11: https://patch.msgid.link/20261016-qce-fixes-skcipher-v11-0-d13ddfe609a4@oss.qualcomm.com

Changes in v11:
- Split out the skcipher patches into a smaller series for easier review
- Drop patch "crypto: qce - Fix CTR-AES for partial block requests" as a
  subsequent commit makes this adjustment effectively dead code
- Fix a mid-series build failure due to an earlier bad rebase
- Link to v10: https://patch.msgid.link/20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com

Changes in v10:
- don't pass a NULL buffer to sg_init_one()
- fix byte order of the imported hash state on empty finalization
- don't recompute the CTR counter in software for every request
- reject skcipher requests with a too short scatterlist
- check fragmentation for empty CCM decryption requests too
- don't use a static loop iterator (duh...)
- initialize the return value in qce_handle_queue()
- Link to v9: https://patch.msgid.link/20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com

Changes in v9:
- Rebase on top of cryptodev/master
- Rephrase Kconfig help text changes
- Link to v8: https://patch.msgid.link/20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com

Changes in v8:
- Add a patch making the crypto driver *not* register algos by default
  but only if the user explicitly requests it with the provided module
  parameter
- Use the "offloader" name for the crypto IP instead of "accelerator"
- Fix device module table issues
- Make the core driver use a list (despite it only having a single
  member now) of child auxiliary devices to register to make it clear we
  have the intention of extending this once we start the work on secure
  media playback
- Link to v7: https://patch.msgid.link/20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com

Changes in v7:
- Add follow-up changes converting the QCE crypto driver to auxiliary
  bus, adding the core QCE driver under drivers/soc/ registering the
  auxiliary device and removing the BROKEN Kconfig label
- Link to v6: https://patch.msgid.link/20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com

Changes in v6:
- Handle all zero-length HMAC finalizations (like imported state with
  data already hashed), not only the genuinely empty message case
- Add an additional patch addressing the fragmented skcipher payload
  issue
- Link to v5: https://patch.msgid.link/20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com

Changes in v5:
- Dropped patch 1/8 that's already queued
- Use the pre-allocated fallback ahash for HMAC transforms (Herbert)
- Link to v4: https://patch.msgid.link/20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com

Changes in v4:
- Remove remaining ECB and DES3 bits
- Pick up tags
- Link to v3: https://patch.msgid.link/20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com

Changes in v3:
- Remove even more algorithms and dead code in patch 1/8
- Link to v2: https://patch.msgid.link/20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com

Changes in v2:
- Add fixes for the full suite of crypto self-tests
- Add Fixes and Cc tags
- Link to v1: https://patch.msgid.link/20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com/
---
 drivers/crypto/qce/common.h |  1 -
 drivers/crypto/qce/sha.c    | 62 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
index 9cd2e6ed8bbb0f76e24be187d8ae7e2fe2f7b932..587d349da91d1faa2bed7cd488306d4358467b2d 100644
--- a/drivers/crypto/qce/common.h
+++ b/drivers/crypto/qce/common.h
@@ -82,7 +82,6 @@ struct qce_alg_template {
 		struct aead_alg aead;
 	} alg;
 	struct qce_device *qce;
-	const u8 *hash_zero;
 	const u32 digest_size;
 };
 
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index b67d749db05f2b9823cd2f0953ef24f4f337df2c..738454dd35655a8376bc878444fcc3fbd7535956 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -7,6 +7,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/string.h>
+#include <linux/unaligned.h>
 #include <crypto/internal/hash.h>
 
 #include "common.h"
@@ -249,18 +250,56 @@ static int qce_ahash_update(struct ahash_request *req)
 	return qce->async_req_enqueue(tmpl->qce, &req->base);
 }
 
+/*
+ * BAM DMA cannot handle zero-length transfers, so the driver always holds
+ * back at least one byte to submit to the engine. A zero rctx->buflen at
+ * finalization time does not necessarily mean the message is empty: the
+ * caller may have imported a state that already reflects some hashed data
+ * with nothing currently buffered. Handle both cases through the software
+ * fallback: reconstruct the running state when there is one instead of
+ * assuming the message is empty.
+ */
+static int qce_ahash_finalize_zero(struct ahash_request *req)
+{
+	struct qce_sha_reqctx *rctx = ahash_request_ctx_dma(req);
+	HASH_FBREQ_ON_STACK(fbreq, req);
+	struct __sha256_ctx core;
+	struct scatterlist sg;
+	int ret, i;
+
+	sg_init_table(&sg, 1);
+	ahash_request_set_crypt(fbreq, &sg, req->result, 0);
+
+	if (rctx->first_blk) {
+		ret = crypto_ahash_init(fbreq) ?: crypto_ahash_finup(fbreq);
+	} else {
+		core = (struct __sha256_ctx){
+			.bytecount = rctx->count,
+		};
+
+		/* rctx->digest is the raw big-endian dump of the engine's regs */
+		for (i = 0; i < SHA256_STATE_WORDS; i++)
+			core.state.h[i] = get_unaligned_be32(rctx->digest +
+							     i * sizeof(u32));
+		if (IS_SHA_HMAC(rctx->flags))
+			core.bytecount += SHA256_BLOCK_SIZE;
+
+		ret = crypto_ahash_import_core(fbreq, &core) ?:
+		      crypto_ahash_finup(fbreq);
+	}
+
+	HASH_REQUEST_ZERO(fbreq);
+	return ret;
+}
+
 static int qce_ahash_final(struct ahash_request *req)
 {
 	struct qce_sha_reqctx *rctx = ahash_request_ctx_dma(req);
 	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
 	struct qce_device *qce = tmpl->qce;
 
-	if (!rctx->buflen) {
-		if (tmpl->hash_zero)
-			memcpy(req->result, tmpl->hash_zero,
-					tmpl->alg.ahash.halg.digestsize);
-		return 0;
-	}
+	if (!rctx->buflen)
+		return qce_ahash_finalize_zero(req);
 
 	rctx->last_blk = true;
 
@@ -292,12 +331,8 @@ static int qce_ahash_digest(struct ahash_request *req)
 	rctx->first_blk = true;
 	rctx->last_blk = true;
 
-	if (!rctx->nbytes_orig) {
-		if (tmpl->hash_zero)
-			memcpy(req->result, tmpl->hash_zero,
-					tmpl->alg.ahash.halg.digestsize);
-		return 0;
-	}
+	if (!rctx->nbytes_orig)
+		return qce_ahash_finalize_zero(req);
 
 	return qce->async_req_enqueue(tmpl->qce, &req->base);
 }
@@ -431,9 +466,6 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 	alg->halg.digestsize = def->digestsize;
 	alg->halg.statesize = def->statesize;
 
-	if (IS_SHA256(def->flags))
-		tmpl->hash_zero = sha256_zero_message_hash;
-
 	base = &alg->halg.base;
 	base->cra_blocksize = def->blocksize;
 	base->cra_priority = 175;

---
base-commit: a29888556578e4695bca25a2807308e9050ee2ac
change-id: 20261016-qce-fixes-sha-a01b32c77ec0

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

