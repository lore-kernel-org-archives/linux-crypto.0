Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F45B488224
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846926; cv=none; b=F8RYCJx2axGsThhWEfVD8kFBzf/6MQGZoDuld5av1Mv5/jNc1gt/IpgsB1QkuC+Cd0aQtm9kluRNfykvL0Surcnus5iG+SW0ETA8UeL2M9g6XPm6cjZrfCW4bIsewr7JEA+sGjTpJYjqiM3mGRlOwShSEVUriWDDawXB+0nd8l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846926; c=relaxed/simple;
	bh=I8krKhJahgIEJ7HiEH76lvoj/BYjFhFqiLB5U5WP74A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DTSknrdwKhUkQyUnuuXqWaRnVAUAPes7gQJV5zrt6haBkLFRrZsJAsJwSwTSeDypot8mjzk4AiysI8gjdv3Yhw4LRgNVrZmVVa1sbtFt9mLdg68bNHlhxWa5tmYh1tgdbNkjkcr7UtmiP6cEHqJh6eu0L4EagTyEN+pl5QEl7Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JVwY129Y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bFTLkUq1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JVwY129Y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bFTLkUq1"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RFcOa43360337
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IPlM6Y0iVHV+fOjO00taADkuu2MuBiXuc3s9hjMOFU0=; b=JVwY129YOPuk83p1
	OS9RZY4wq1W/fBzbVhYuzQ46IQYLJu9nhcJJE3s/iD58RZC46hZDN3V9kJ3WjGOs
	hWPlvWLjLUQ0T22iu+0H4ntZykCjCuf2OaAcjGenuInkJrWOeCUlLVEKSNUDx9nP
	B4YyI+t7M/DENNv+8QgnCzMs4sg6DtTTSwdgGZ1PDwXzvXcUJMvvja9rHLz5hsH6
	33R0G2Ko8JB+pczAODx9Z9UsnljogPXcdL+eVMH3u50OiGsgNXOr8e7MICq9OOjw
	gfjl46ekKYQ47F+KzWahu7RUDq5W7u5DRom1anSB+zQ58GtxwMEVTHOOQdTwI/n4
	UIvvxA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gab7t39fq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:08:43 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so115215a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 09:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787846923; x=1788451723; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IPlM6Y0iVHV+fOjO00taADkuu2MuBiXuc3s9hjMOFU0=;
        b=bFTLkUq1vSjAB8cx8cOgE/Tgp7m312UZYmE8DLrNOUxZ8u0dJEeGq2STwIi6xnJQPj
         lu+kd88hCOdV/gEw4nHE4/JuCZ4SeM0nC9BsKi5c/E3GG07rGnoVzzU3Vfg5hLvmtvJQ
         QD7awuoQNz1hcpV3r7RqBESsA5Ln42aUDqjvUITX5UF/ZJYh6w9a2Z9F2JG3F/j/tEkx
         bLEIygQ64BXheBpVwvdzaEYnEl/Uk+MOOzodrakQr8quCZ7BtZkmWhDi+UnuZ2gUMYwR
         vPBh6/1BdLpAs4R8y/y2awCOp7y7wb1PsQAweCUT6/TENmU09OmfSypoXc2Ds7IQstuE
         PlVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787846923; x=1788451723;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IPlM6Y0iVHV+fOjO00taADkuu2MuBiXuc3s9hjMOFU0=;
        b=ZpKAmgvJmz+gRKqgs3VWx5Upb+jEnKYYETCnLJtRNl3bcgvdqGv4ACUNcus0nG4Adq
         cQ5n/D8M5txYODI+DB7RivRRt9hGZHtPx80/7MJOJwp+X/qDx7Uw4KrryC5n7efPwHTX
         g128Xy/jOBKWrI6cgSorUKSBZroLwL2J22ddQD8l+v+zmyv+xl82v5pi6sdXMxQx51VY
         d9ZjoqX4UgPDSVR8EdE4qTStd2uXSWvZb3J5X01RuUrH58w0OrVhgSiAQS/HOIUjxwz0
         LtgjkrMiP1Ovl1izbK/rX8+UO7IcwEGQQCsa/IptDiICkjdfr47cybEzKhOJ9wvBZefd
         1SiQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr2xzajfWiujZnL7mdebsfHFXKSOGIrEDna6zWWOijZSGe/5nJL2RDv+ZXTZ7dgKANn9gyGB5eGTXt1070=@vger.kernel.org
X-Gm-Message-State: AFuF++mR2HR8oH4fHUj08+33W7jGDjvO0F0Wyluy9XkPO5u+g11QXVpZ
	GC3J9Of2E8YtXXjygBKidI4Tf+D6SP20f94nletGQ7nAa9fZqZ98DjMMRoRkqx8bYqDc5Y2qUTl
	OY9OnRaLOWGrePJf5ScAXOasjkAvbyYS3ZOR7g8tBtDrKCOKett3wHs1YnPgHe0oRYvk=
X-Gm-Gg: AR+sD11G2P3vflqG1LRLkGtRH6hBpmQESLTH04/x8vCthwNbFE9T86xO5xYfkakKd1C
	zGvX9usHGuJ5PyW4R6huiR47r68EHH6UX0b05K/mePN6t60JNjSfNdnGb5tEd3tUlplfd2UNGEU
	ci+7gainPLEv4AphrmL+rtWGlg1viHzqPSl0lIwYkFA5RWu1Ga5x1C8xg0B966EIJx/ByJjplU/
	HTxd2H4rkmc0QOCitd3rZcDseA0PM4aruTAD/JByrh8cNR+2XEYYkU4h0WwX0DaNO8/TpnD8UpI
	pn0+CVt2/ipYkvoRwEO2DsrIsmhcip0H0xwJB5kKcph70G6Kdw7woaZvqGJlQOTvbOMH6tMfIpZ
	odYXxxkogO3g33/Dq0J8oKzF5j0UJziSjMMFBHQNzdSGlAVQdDMDR6YIVukk=
X-Received: by 2002:a17:90b:4d0c:b0:37f:c97a:939f with SMTP id 98e67ed59e1d1-396d0dd5069mr450681a91.7.1787846922305;
        Thu, 27 Aug 2026 09:08:42 -0700 (PDT)
X-Received: by 2002:a17:90b:4d0c:b0:37f:c97a:939f with SMTP id 98e67ed59e1d1-396d0dd5069mr450573a91.7.1787846921737;
        Thu, 27 Aug 2026 09:08:41 -0700 (PDT)
Received: from u24-san1p10108.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd9085sm3245892a91.12.2026.08.27.09.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 09:08:41 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: ebiggers@kernel.org, axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
Subject: [PATCH v1 09/11] soc: qcom: add ICE keyslot partitioning driver for guest VMs
Date: Thu, 27 Aug 2026 09:07:18 -0700
Message-ID: <20260827160806.1295313-10-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=X6Bi7mTe c=1 sm=1 tr=0 ts=6a90610b cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=w3opuUzClo5xMoDqJE4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: dOnazoM4qHYnkQcwGc_KB77QlqKgI1ns
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfXzCvEMc6ab9zG
 mEWNI7h2c4rKH7BaaybV8b4D6pYGgEhaIGu4HQeB+u+8V5aJNegzkqAxjZa9aWpCtQj4guTia74
 Cl/u0ofwNKBzoO2UiVMB/twV4W4Cq4g=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX3ww07PdJ9o/9
 vaZS+QAEeU6TuCdmZWuME5BIzRnm441Kc8nugMwG5PXwPN+9O7zT25U32fIpmm5m2ktgDyhvfRy
 Na2s8dzazomUrYz4pLr2aQi7uSFOU7FG5NAQzu/gek7TLXuEwDZYA81l3z7mePBmipCBT5/CZ2v
 XByZbksbOV863wIZxCSvixlXUalPxBgwkzJfVviJgTAqMvQPvSs9QdMuCloFpYPuMvdtGHyeprP
 YbjOse77IDKlahW6d7T4yEmEtEZUx22ydr5iLdo/EFDNzACWyz+J33FHFN4y4meuN6lUnN7CZOF
 jw4i1bfjxTwdutn6Oi5H9rS/JIIn7u2tQ2Tq60iahc0gp67K2O+Nv5TgHyDHPKezFTMzxOBpwb0
 BpEKarMGX5sRKYPjlZGWEih1XJsSTpCqftygkE/ySNWnO3HWd2GZXoFRZaQwQ7RUlxEoRfXO9nG
 JSe/P4wp1bKvjpB5KRQ==
X-Proofpoint-GUID: dOnazoM4qHYnkQcwGc_KB77QlqKgI1ns
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_07,2026-08-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270136

From: linlzhan <linlin.zhang@oss.qualcomm.com>

On Qualcomm platforms the ICE hardware has a fixed number of physical
keyslots shared across the host and all guest VMs.  A userspace
virtio-blk backend handling VIRTIO_BLK_T_CRYPTO_IN/OUT requests needs
to translate a guest's virtual keyslot index to the corresponding
physical ICE keyslot without letting one VM access another VM's slots.

Add QCOM_ICE_SLOTS, a platform driver that implements bcp_slot_virt_ops
for the /dev/blk-crypto-proxy device.  It parses a
qcom,ice-keyslot-map device-tree node describing the per-VM keyslot
allocation table, where each child entry maps a guest_id to a
contiguous physical slot range [slot_offset .. slot_offset +
max_ice_slots).  Entry 0 is reserved for the host; guest entries start
at index 1 and are excluded from the guest-facing translation so that
blk-crypto-proxy cannot accidentally route a guest request into the
host's physical keyslots.

The driver exposes two callbacks:

  get_guest_slots()  — return the number of ICE keyslots allocated to
                       a given guest_id; used by BCP_GET_CRYPTO_CAPS to
                       populate the max_slots field in the virtio config
                       space.
  vslot_to_pslot()   — translate a (guest_id, virtual-slot) pair to the
                       corresponding physical ICE keyslot index; used by
                       BCP_SUBMIT_IO_BY_VSLOT before calling
                       bio_crypt_set_ctx_by_slot().

The singleton pointer to the parsed table is RCU-protected; the hot
path reads it lock-free.  Probe validates that no two VM entries share
a guest_id or overlapping physical slot ranges.

Note: This patch is submitted for visibility. The keyslot partitioning
is based on the current DT-based keyslot allocation with vm_id known.
We are aware this may be revised to use a TZ SCM query interface in a
future version of this series, submit it RFC for design discussion.

Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
---
 drivers/soc/qcom/Kconfig          |  18 +++
 drivers/soc/qcom/Makefile         |   1 +
 drivers/soc/qcom/qcom_ice_slots.c | 232 ++++++++++++++++++++++++++++++
 3 files changed, 251 insertions(+)
 create mode 100644 drivers/soc/qcom/qcom_ice_slots.c

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 6c632d114d45..e1f383b4dc63 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -294,6 +294,24 @@ endif
 # Options selected by other drivers from different subsystems must be outside
 # of the menuconfig if-block:
 
+config QCOM_ICE_SLOTS
+	tristate "Qualcomm ICE keyslot partitioning for VM guests"
+	depends on ARCH_QCOM || COMPILE_TEST
+	depends on BLK_CRYPTO_PROXY
+	depends on BLK_INLINE_ENCRYPTION
+	help
+	  Parses the qcom,ice-keyslot-map device-tree node and provides
+	  per-VM ICE keyslot accounting and virtual-to-physical slot
+	  translation for guest VMs sharing ICE hardware on Qualcomm
+	  platforms.
+
+	  When enabled, guest virtual keyslot indices are mapped to the
+	  physical ICE keyslot range allocated to each VM, preventing one
+	  VM from accessing another VM's keyslots.
+
+	  Say M here when multiple VMs share ICE keyslots on a Qualcomm
+	  platform.  If unsure, say N.
+
 config QCOM_INLINE_CRYPTO_ENGINE
 	tristate
 	select QCOM_SCM
diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index 6d4b7546d1fb..952a57554f9d 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_QCOM_LLCC) += llcc-qcom.o
 obj-$(CONFIG_QCOM_KRYO_L2_ACCESSORS) +=	kryo-l2-accessors.o
 obj-$(CONFIG_QCOM_ICC_BWMON)	+= icc-bwmon.o
 qcom_ice-objs			+= ice.o
+obj-$(CONFIG_QCOM_ICE_SLOTS)	+= qcom_ice_slots.o
 obj-$(CONFIG_QCOM_INLINE_CRYPTO_ENGINE)	+= qcom_ice.o
 obj-$(CONFIG_QCOM_CRYPTO_VIRT)	+= crypto_virt.o
 obj-$(CONFIG_QCOM_PBS) +=	qcom-pbs.o
diff --git a/drivers/soc/qcom/qcom_ice_slots.c b/drivers/soc/qcom/qcom_ice_slots.c
new file mode 100644
index 000000000000..364ac93077c1
--- /dev/null
+++ b/drivers/soc/qcom/qcom_ice_slots.c
@@ -0,0 +1,232 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * qcom_ice_slots.c - Qualcomm ICE keyslot partitioning for guest VMs
+ *
+ * Implements bcp_slot_virt_ops: translates a (guest_id, virtual-slot) pair to
+ * a physical ICE keyslot index using a per-VM allocation table parsed from
+ * the device-tree node with compatible = "qcom,ice-keyslot-map".
+ *
+ * Device-tree layout:
+ *
+ *   ice_keyslot_map: ice-keyslot-map {
+ *       compatible = "qcom,ice-keyslot-map";
+ *       #address-cells = <1>;
+ *       #size-cells = <0>;
+ *
+ *       vm@3  { reg = <3>;  qcom,max-ice-slots = <16>; qcom,ice-slot-offset = <0>;  };
+ *       vm@52 { reg = <52>; qcom,max-ice-slots = <32>; qcom,ice-slot-offset = <16>; };
+ *   };
+ *
+ * Each child entry maps a guest (reg = guest_id) to a contiguous physical keyslot
+ * range [slot_offset .. slot_offset + max_ice_slots).
+ *
+ * Entry 0 is always the host's own reservation.  Entries 1+ are guest
+ * reservations.  The host's entry is used by ufs-qcom to size its
+ * blk_crypto_profile; it is excluded from the guest-facing translation table
+ * so that blk-crypto-proxy can never accidentally route a guest request into
+ * the host's physical keyslots.
+ *
+ * The ufs-qcom driver reads the host slot info and validates all entries
+ * against the hardware slot count directly via the OF API, with no symbol
+ * dependency on this module.
+ */
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/rcupdate.h>
+#include <linux/slab.h>
+#include <linux/blk-crypto-profile.h>
+#include <linux/blk-crypto-proxy.h>
+
+#define QCOM_ICE_SLOTS_MAX_ENTRIES	8
+
+struct qcom_ice_slot_entry {
+	u32 guest_id;
+	u32 max_slots;
+	u32 slot_offset;
+};
+
+struct qcom_ice_slots {
+	struct qcom_ice_slot_entry entries[QCOM_ICE_SLOTS_MAX_ENTRIES];
+	unsigned int num_entries;
+};
+
+/*
+ * There is at most one qcom,ice-keyslot-map platform node per SoC.  A single
+ * global pointer is set at probe time and cleared at remove time.  The
+ * hot-path read (from bcp_slot_virt_ops callbacks) is protected by RCU;
+ * probe/remove serialise via the platform driver guarantee.
+ */
+static struct qcom_ice_slots __rcu *g_ice_slots;
+
+static struct qcom_ice_slots *virt_lookup(struct blk_crypto_profile *profile)
+{
+	/* Single UFS controller: profile argument is not needed. */
+	return rcu_dereference(g_ice_slots);
+}
+
+static int qcom_ice_slots_get_guest_slots(struct blk_crypto_profile *profile,
+					  u32 guest_id)
+{
+	struct qcom_ice_slots *virt = virt_lookup(profile);
+	unsigned int i;
+
+	if (!virt)
+		return -ENOKEY;
+
+	/* entries[0] is the host; guest entries start at index 1. */
+	for (i = 1; i < virt->num_entries; i++) {
+		if (virt->entries[i].guest_id == guest_id)
+			return virt->entries[i].max_slots;
+	}
+	return -ENOKEY;
+}
+
+static int qcom_ice_slots_vslot_to_pslot(struct blk_crypto_profile *profile,
+					 u32 guest_id, u32 virt_slot,
+					 unsigned int *phy_slot_out)
+{
+	struct qcom_ice_slots *virt = virt_lookup(profile);
+	unsigned int i;
+
+	if (!virt)
+		return -ENOKEY;
+
+	for (i = 1; i < virt->num_entries; i++) {
+		if (virt->entries[i].guest_id != guest_id)
+			continue;
+		if (virt_slot >= virt->entries[i].max_slots)
+			return -EINVAL;
+		*phy_slot_out = virt->entries[i].slot_offset + virt_slot;
+		return 0;
+	}
+	return -ENOKEY;
+}
+
+static const struct bcp_slot_virt_ops qcom_slot_virt_ops = {
+	.get_guest_slots = qcom_ice_slots_get_guest_slots,
+	.vslot_to_pslot = qcom_ice_slots_vslot_to_pslot,
+};
+
+static int qcom_ice_slots_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *child;
+	struct qcom_ice_slots *virt;
+	unsigned int idx = 0, total_slots = 0;
+	int ret = 0;
+
+	virt = devm_kzalloc(dev, sizeof(*virt), GFP_KERNEL);
+	if (!virt)
+		return -ENOMEM;
+
+	for_each_child_of_node(dev->of_node, child) {
+		u32 guest_id, max_slots, slot_offset;
+		unsigned int j;
+
+		if (idx >= QCOM_ICE_SLOTS_MAX_ENTRIES) {
+			dev_err(dev, "too many vm entries (> %u)\n",
+				QCOM_ICE_SLOTS_MAX_ENTRIES);
+			ret = -EINVAL;
+			of_node_put(child);
+			goto err_free;
+		}
+
+		if (of_property_read_u32(child, "reg", &guest_id))
+			continue;
+		if (of_property_read_u32(child, "qcom,max-ice-slots", &max_slots))
+			continue;
+		if (of_property_read_u32(child, "qcom,ice-slot-offset", &slot_offset)) {
+			dev_err(dev, "missing qcom,ice-slot-offset for guest_id=%u\n",
+				guest_id);
+			ret = -EINVAL;
+			of_node_put(child);
+			goto err_free;
+		}
+
+		if (idx > 0 &&
+		    slot_offset <
+		    virt->entries[idx - 1].slot_offset +
+		    virt->entries[idx - 1].max_slots) {
+			dev_err(dev, "slot overlap: guest_id=%u overlaps guest_id=%u\n",
+				guest_id, virt->entries[idx - 1].guest_id);
+			ret = -EINVAL;
+			of_node_put(child);
+			goto err_free;
+		}
+
+		for (j = 0; j < idx; j++) {
+			if (virt->entries[j].guest_id == guest_id) {
+				dev_err(dev, "duplicate guest_id=%u\n", guest_id);
+				ret = -EINVAL;
+				of_node_put(child);
+				goto err_free;
+			}
+		}
+
+		virt->entries[idx].guest_id = guest_id;
+		virt->entries[idx].max_slots = max_slots;
+		virt->entries[idx].slot_offset = slot_offset;
+		total_slots += max_slots;
+		idx++;
+	}
+
+	if (idx == 0) {
+		dev_err(dev, "no VM entries found in qcom,ice-keyslot-map\n");
+		ret = -EINVAL;
+		goto err_free;
+	}
+
+	virt->num_entries = idx;
+
+	/*
+	 * Publish the singleton.  From this point on, bcp_slot_virt_ops
+	 * callbacks can resolve virt via rcu_dereference(g_ice_slots).
+	 */
+	rcu_assign_pointer(g_ice_slots, virt);
+
+	ret = bcp_register_slot_virt_ops(&qcom_slot_virt_ops);
+	if (ret) {
+		dev_err(dev, "failed to register slot_virt_ops: %d\n", ret);
+		goto err_free;
+	}
+
+	dev_info(dev, "registered: %u VMs, %u total ICE slots\n",
+		 idx, total_slots);
+	return 0;
+
+err_free:
+	return ret;
+}
+
+static void qcom_ice_slots_remove(struct platform_device *pdev)
+{
+	bcp_unregister_slot_virt_ops(&qcom_slot_virt_ops);
+	/*
+	 * Clear the singleton under RCU so that any concurrent ioctl that
+	 * already took the read lock and is mid-lookup sees either the old
+	 * valid pointer or NULL, never a freed pointer.
+	 */
+	rcu_assign_pointer(g_ice_slots, NULL);
+	synchronize_rcu();
+}
+
+static const struct of_device_id qcom_ice_slots_of_match[] = {
+	{ .compatible = "qcom,ice-keyslot-map" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, qcom_ice_slots_of_match);
+
+static struct platform_driver qcom_ice_slots_driver = {
+	.probe  = qcom_ice_slots_probe,
+	.remove = qcom_ice_slots_remove,
+	.driver = {
+		.name           = "qcom-ice-slots",
+		.of_match_table = qcom_ice_slots_of_match,
+	},
+};
+module_platform_driver(qcom_ice_slots_driver);
+
+MODULE_DESCRIPTION("Qualcomm ICE keyslot partitioning for guest VMs");
+MODULE_LICENSE("GPL");
-- 
2.34.1

