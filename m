Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA074345EDB
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792159920; cv=none; b=OXXKNoaJ6lANWNkFJPIwsHTszl4jgmFk7b9rx0fo3nq33BSNYLwXfOo1pvTupYnS2aEh+0ca+iy9fdqke5LKNo9SXWo8+SOQlq4i1yfx1jNNM/aGCxz7jbKOtmE39i2k6PgmOmr7W0cnlaqv9D0WfAU2hL1Uxn97Gx1iW4SBqOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792159920; c=relaxed/simple;
	bh=AjOlvVJQS//DsvCuefdKjOocvAsT0+tW+iqMVZga33c=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=FJK6ZlryTSp0O80o63KYCbaZ9BHZv51BMtKudjIBRFXUkoxaFQFA+xtNGezwauGSrJXwgiK+7puje+8qOJ9kRXncfRQVt8AnJjo6XYK4noWXY05Abeq9wzft9pQntSPOO+pHItB10G1EpnCp6+Pbav2cEnzYFPNZI+51Ohwiljs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eXadYWpf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QTmg5NJW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eXadYWpf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QTmg5NJW"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE5w0c2914826
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=1byDc83PlgEFqClSIW/YQ5
	2JFlcU14c6UW3k5RoQVkU=; b=eXadYWpfZjCOh9tyzIyF85QCi/uAkszfnQNy0y
	WbRalV7RNTdNotgEzIp0dP1ujsCFotN+xS131Sf7Yl8H+unBT1BRdNHC3iPS7HSA
	DzaOhpo7rXtNSekyh0f1wwA9wHyj6NhGFKFpLbqGsnMJEww9HSkKu2Nve3S+Ckfp
	WZEy5n1kzH341POhgm6ObeUjiScWDy/KMo48QwUdAcUqn66DasQlhlvt8tCZhk3u
	+7pjmsc3k80HXUOQKkbhejQHxchYphxCzP6n8Y2bwc3tgM+EGvmeva/bCGe5XX7z
	w5aefN0Otlni1jt5PmJZugMMMPehrSk0dPz5OLmCx5ITO/Fg==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbmmq072v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:11:56 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91792488228so329656d6.2
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 07:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792159916; x=1792764716; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1byDc83PlgEFqClSIW/YQ52JFlcU14c6UW3k5RoQVkU=;
        b=QTmg5NJWG6+kExiAjg/CX3bgTkP+0LLwDRbLAHTJoYnMef3VQaVIy0QF0TqqDOaNrp
         riVgD21n4sTcKg3hDE/+TsWrNUfkzFO/n9ck32YRbiQSbcZiUKxzncPIrxnjwI61IUKe
         OC2Vqe1uIybkALQn8UrCgckfESeUW+VQIXA/yiWr+EPCHGz796fIb6A91hDdGXx4O0W7
         DBsJ7o/Fz7wFW8vyasqCPCwjK1GJiWloABmNesy2tcEjXg/tIUJyJcz/AqfHkOfUD92g
         OgHwbPcVuXtoyhtcys2+Pup99s/ECd2nw9vpKRy1EbYbGlp7FiQHdua4DJatNMtKu3fF
         t6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792159916; x=1792764716;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1byDc83PlgEFqClSIW/YQ52JFlcU14c6UW3k5RoQVkU=;
        b=s0wcQ3LwruDJu6tQuX4yl9up2GZ0bxgJfXDevrdYHe2qkzjxINNlL7vJc/ZU0VR4u0
         47bEChum2N1Z4nV7aiCWI0u5P3LzMwmvIDM1/BNjfcXSaDhfdT86Az9qTqBh5lUoKj5u
         OatFZyUJ6jIUiF/ejoetFMy6NuzfnUfVPP1wBHeCStJn9btqXb3p1uLqifZSc1d++BU2
         2ljUtKhQ3IOflDEIO6FRQSCYAlSqGki9MIswMKdMu6dTYtbMtDNE/06fMjSE+oq+6dCq
         fSGRVVJtVfwlZooLzTzHgi81PqyQnieniDFtnF0SSHoaK838VwqKC8MBdAGxuUpbGRfH
         Jhhg==
X-Gm-Message-State: AFq9FYIT7eix6JTiOMCEEvcQ7H2jn5n+1zr0BoaYPnFlLKoFtf3r7OHt
	8GxMc6gDkjxDdWwrOzX+6dXEIcVLnZqMC3d6U59WquGLawFgNMPT+YyOTMB1UsUxC2Ti1x7pzZt
	6Q9JZIqPWw4iWYB/pV8habIdqwKG9bwW0Z1+uevwB1pGwcVZbgcPYEPzFMILe/gtQ7tjFv90GJI
	4=
X-Gm-Gg: AYBFou3+tq3UYV4g7bctB8JtiTG/680j7Z1xYOplFvdFBWzd8tjSe2yAtzY64H0Ujj1
	qUh3ltqPxqq4ektPTvIr3pdGGeoPFMzhOK3PPotiEFUaOQok2+V63ukJJSelfRBxf9e8uGWr2Bj
	3uNjhycPNs1JLyTNoMtJL5n+2kT1oUlTPnDKkI6AIIdCcYkNgs9sAqbTA1ISla1Z0MhREVJlRxO
	Sf6Oq/nArxkR2cOQZgkwhzFZC+Wxvb2Y33O8CwbqX7z6anAFFyDcODgqytFTbrJ22JULacu+5bm
	uysFAP7D1ZXYRZFVY3t4iRh11rhTvh+TjnNyWZbLEnnBkrCsI8LXP/qchBqlaEWz4JcexbHOhlW
	F96tD1C8EB2X/vJ490MH7WfLNfuxa
X-Received: by 2002:a05:620a:4411:b0:93e:7ec5:2d65 with SMTP id af79cd13be357-93ebd20b8f0mr3679549885a.31.1792159915828;
        Fri, 16 Oct 2026 07:11:55 -0700 (PDT)
X-Received: by 2002:a05:620a:4411:b0:93e:7ec5:2d65 with SMTP id af79cd13be357-93ebd20b8f0mr3679541585a.31.1792159915227;
        Fri, 16 Oct 2026 07:11:55 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f8babsm5760145f8f.33.2026.10.16.07.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:11:54 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH v11 0/4] crypto: qce - fix self-test issues in skcipher
Date: Fri, 16 Oct 2026 16:11:45 +0200
Message-Id: <20261016-qce-fixes-skcipher-v11-0-d13ddfe609a4@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKEw0moC/x2LSwqAMBDFriKzdqCtWsSriItSnzoIfjoggnh3i
 8uE5CFFEih1xUMJl6jsWwZry4LiErYZLGMW5Izz1ljPZwRPckNZ1yjHgsQwVVsH3xi4hvJ4JPx
 F/vrhfT/jvXubZQAAAA==
X-Change-ID: 20261016-qce-fixes-skcipher-e0384a650e25
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
        linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4065;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=AjOlvVJQS//DsvCuefdKjOocvAsT0+tW+iqMVZga33c=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq0jCjF/ApNt06fNbT487zzn+mpbTpLSUYBXIDt
 3o4ikMWHe+JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatIwowAKCRAFnS7L/zaE
 wxFVD/4/b2oyMXUj5o7TwUpj5efwfrLwfZGI0ImidbuoLepHmnJ7t1hxoPEohtNIsASNq78tx8k
 /dwm7rmYalGwJJBb/7iyUS7Kwr1UqVdxI/T3iub0EBIpTXJPfcaL5PA8pwjj+cR2Y9/+gi/B8ME
 8lvluOQiuH8BWKq0yQPVnfh4pZ7/HQUOOLwpVwHwoKPT68S+l8X28Tw4DdjGWcjB9//QIIOhiNY
 shFPTujfUvYtkVBF41NJ0hGNY3Po9jME3FoiCAN/3Crx5VmXHDM9i0b471cSozyh3vP0u25mJ7x
 6H43PxiO4A1mJPZlYB+jKuetKoqZNIjPxZXBmnmfM+m5wPqSh5OYF3NB6DADFimiA8E/7zCiPdo
 LAVZZk+N1lYt9zwlFxAJz82MPpKkvh3wUE7QtACO9gAZ8hvr8xJW2F7pwSssn9wNWdNjAjC4ucd
 Kvvmz6HoTs4BB421h101YgsBXwBEsvOfzoLm5wulPVwBNdlc28V1ilH4cBAgtB970o93IPmbfst
 Hhp307G3WUiVvDXIBQ5oMkBHzpFpNZCbqxvh7Qn3IymrFzNam/BBeZjBS4yCB5Ddzrij8LvmTPk
 gwDPdxXyH0q/xRycT4hn9F5t45zP4rRDamv9eB+VCt4IVtvZaTlx6zz+/+2fTHHXSIrJ4fOG++j
 zgmyUqACLb2MY+Q==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1NiBTYWx0ZWRfX+h0wARyhus3i
 pGoa4g3z1/Lha0uesLXWuxmE85I22PpCTu6zZNTChZsy9YHhmvMlw0O2Y0jsi5OOYHUAwmQahWK
 pfAHMqRSMOeCK1RvkZ1LgvnfkBSliEM=
X-Authority-Analysis: v=2.4 cv=P9uvFSAu c=1 sm=1 tr=0 ts=6ad230ac cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=iK5QPMNa_E_FA8V_BHUA:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1NiBTYWx0ZWRfXxtyuqQPWk0b3
 4E0GNCA6jmTeMeUOSz+KcWzeFwvc+/wRdu5HIiatcPxAGYZXlyZJ95mvqR3hBNLB4XpjUL1XVva
 8wT9YqHTAgCimlWYXAJgCNtmU4G1tk6Dplt++GqK4RhTCb7Nu9FH6hOOOu9+3j0gk0LgDK1pxt1
 2VHEecP4oq7+sJUV6PGO008KQ/LObRqRjWMt90qEqZoR4fjA45Xv3Jp9V1Sswok9xiJKwsSMAse
 0Et29kZ5gyBXGtIeNi79ZMt1ve3I89LZEA6h6kn9OpkbblJk1uOwRpjsPXEBdrXO35P88UqwK/G
 EVUHrONNMJCeOHCKMxEfX/J21VlGLaQWMYd6ZerDImg8yw52IZvhD4S//eplR5AWTLKwhOJ4iRJ
 uoZzyEyuJjc/+GDV29Oz6s0ADEKOP6WCTwgq21fFRVhvN1Ymp3SVSUxCvMASjRiIldx9LhWMA+p
 Iusp1g4Xkb4OY+1znBA==
X-Proofpoint-GUID: FYyxx7djGAb10-KqUQBQARf45xWf6hjk
X-Proofpoint-ORIG-GUID: FYyxx7djGAb10-KqUQBQARf45xWf6hjk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160056

As requested by Herbert: this is the first of smaller series wits fixes
for QCE. This one contains the patches addressing issues in skcipher.c.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
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
Bartosz Golaszewski (3):
      crypto: qce - Reject empty messages for AES-XTS
      crypto: qce - Use a fallback for AES-CTR with a partial final block
      crypto: qce - Use fallback for fragmented skcipher payloads

Kuldeep Singh (1):
      crypto: qce - Fix xts-aes-qce for weak keys

 drivers/crypto/qce/cipher.h   |  1 +
 drivers/crypto/qce/skcipher.c | 39 ++++++++++++++++++++++++++++++---------
 2 files changed, 31 insertions(+), 9 deletions(-)
---
base-commit: f0f20b900bbb8bdcfaf6cb282787854067d8eec8
change-id: 20261016-qce-fixes-skcipher-e0384a650e25

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

