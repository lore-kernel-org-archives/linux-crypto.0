Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26812CD13D2
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Sep 2023 15:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjIRP1v (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Sep 2023 11:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjIRP1Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Sep 2023 11:27:25 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609051FE5
        for <linux-crypto@vger.kernel.org>; Mon, 18 Sep 2023 08:24:25 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-51e28cac164so12278255a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 18 Sep 2023 08:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1695050554; x=1695655354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+qntkmutwprS+2oQeQzgmaP97TAaIsTbzLeg5qvDo3I=;
        b=PIMZkkONKhG/1HEnIPmtRN10fnJgWai2p0mK+jrxsPxWNls01P9PsVpvvhiEOTzyin
         Ku6VTeZoM2aVXPo6JRROIByWJqdHJjB7XmbKFyI3OPd2/9o4tRsWbMJUcPzBzo74VSJa
         HJ6gi1jGXzzmhRTJFkZjdudZvcr3j6pMIeVhdqTq/j3995XSH0P7iHyVeWLlx60wo8gd
         cNRbv004pz+CTZzWYlVkjs53oYdhqzUhqGAG8Ywy+jxscGsdXwwTeaL0dJabUF3M1JKP
         K89gOvGRoOL+hTCGVtjOON7clbXcF5Acc9Dn0FsIzDhVmQ3REGPPQ2Nyr8KKPhQlfeD5
         l27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695050554; x=1695655354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+qntkmutwprS+2oQeQzgmaP97TAaIsTbzLeg5qvDo3I=;
        b=QiFxIaPPdQh6golZktVfnoqVKCIAcMZZ8C6wAp1u2ueEth3CrCeIi6hTFSdwlkWJqy
         0NW397a05CURjIfkmCLpVnitz64cCqTe4ul2XiJvRUwBQ06bBjIuqQuKWT9cwpm4AG2g
         oq0zqOyquynfCliXs8ZpnkUwR5hPIW8872mpw5WOCpQ+yYEO6tLWKoACKWaBzfoYwWE0
         0WjHqbiawJS8V+lYMxssCBTLkL86VrOgMsWRbboO/DM/d1V+LFuQb4z/hSW5FyUAQ2w2
         1o1Qt+W+wsK2TwpE86Ps/348sRKOTofpFHdoIG2o3MEI1N2RWLrJvh1p+yie7vRAxj5p
         2+gA==
X-Gm-Message-State: AOJu0Yx3b7ue0qinyCheaDvIfxJ6FB8Xm+940YXIYlcwlV/AyhqfOEaG
        GiTMo4Gav+1ozcob0LaHp2BfoRJyNz5N7NO16cz7Bg==
X-Google-Smtp-Source: AGHT+IG2rNuc/qU7cun35uIs/6xu+f6PNjQcCosf7tlGzspNosTVVLVBRGNxbIq/UI3P0ddJC/NsSA==
X-Received: by 2002:a17:907:3e91:b0:9aa:206d:b052 with SMTP id hs17-20020a1709073e9100b009aa206db052mr17366327ejc.27.1695046722736;
        Mon, 18 Sep 2023 07:18:42 -0700 (PDT)
Received: from localhost ([82.150.214.1])
        by smtp.gmail.com with UTF8SMTPSA id g24-20020a170906199800b0099364d9f0e9sm6530301ejd.102.2023.09.18.07.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 07:18:42 -0700 (PDT)
From:   David Gstir <david@sigma-star.at>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     David Gstir <david@sigma-star.at>, Shawn Guo <shawnguo@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        sigma star Kernel Team <upstream+dcp@sigma-star.at>,
        David Howells <dhowells@redhat.com>,
        Li Yang <leoyang.li@nxp.com>, Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tejun Heo <tj@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-security-module@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Subject: [PATCH v3 3/3] doc: trusted-encrypted: add DCP as new trust source
Date:   Mon, 18 Sep 2023 16:18:25 +0200
Message-ID: <20230918141826.8139-4-david@sigma-star.at>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230918141826.8139-1-david@sigma-star.at>
References: <20230918141826.8139-1-david@sigma-star.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update the documentation for trusted and encrypted KEYS with DCP as new
trust source:

- Describe security properties of DCP trust source
- Describe key usage
- Document blob format

Co-developed-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Richard Weinberger <richard@nod.at>
Co-developed-by: David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Signed-off-by: David Oberhollenzer <david.oberhollenzer@sigma-star.at>
Signed-off-by: David Gstir <david@sigma-star.at>
---
 .../security/keys/trusted-encrypted.rst       | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/Documentation/security/keys/trusted-encrypted.rst b/Documentation/security/keys/trusted-encrypted.rst
index 9bc9db8ec651..4452070afbe9 100644
--- a/Documentation/security/keys/trusted-encrypted.rst
+++ b/Documentation/security/keys/trusted-encrypted.rst
@@ -42,6 +42,14 @@ safe.
          randomly generated and fused into each SoC at manufacturing time.
          Otherwise, a common fixed test key is used instead.
 
+     (4) DCP (Data Co-Processor: crypto accelerator of various i.MX SoCs)
+
+         Rooted to a one-time programmable key (OTP) that is generally burnt
+         in the on-chip fuses and is accessible to the DCP encryption engine only.
+         DCP provides two keys that can be used as root of trust: the OTP key
+         and the UNIQUE key. Default is to use the UNIQUE key, but selecting
+         the OTP key can be done via a module parameter (dcp_use_otp_key).
+
   *  Execution isolation
 
      (1) TPM
@@ -57,6 +65,12 @@ safe.
 
          Fixed set of operations running in isolated execution environment.
 
+     (4) DCP
+
+         Fixed set of cryptographic operations running in isolated execution
+         environment. Only basic blob key encryption is executed there.
+         The actual key sealing/unsealing is done on main processor/kernel space.
+
   * Optional binding to platform integrity state
 
      (1) TPM
@@ -79,6 +93,11 @@ safe.
          Relies on the High Assurance Boot (HAB) mechanism of NXP SoCs
          for platform integrity.
 
+     (4) DCP
+
+         Relies on Secure/Trusted boot process (called HAB by vendor) for
+         platform integrity.
+
   *  Interfaces and APIs
 
      (1) TPM
@@ -94,6 +113,11 @@ safe.
 
          Interface is specific to silicon vendor.
 
+     (4) DCP
+
+         Vendor-specific API that is implemented as part of the DCP crypto driver in
+         ``drivers/crypto/mxs-dcp.c``.
+
   *  Threat model
 
      The strength and appropriateness of a particular trust source for a given
@@ -129,6 +153,13 @@ selected trust source:
      CAAM HWRNG, enable CRYPTO_DEV_FSL_CAAM_RNG_API and ensure the device
      is probed.
 
+  *  DCP (Data Co-Processor: crypto accelerator of various i.MX SoCs)
+
+     The DCP hardware device itself does not provide a dedicated RNG interface,
+     so the kernel default RNG is used. SoCs with DCP like the i.MX6ULL do have
+     a dedicated hardware RNG that is independent from DCP which can be enabled
+     to back the kernel RNG.
+
 Users may override this by specifying ``trusted.rng=kernel`` on the kernel
 command-line to override the used RNG with the kernel's random number pool.
 
@@ -231,6 +262,19 @@ Usage::
 CAAM-specific format.  The key length for new keys is always in bytes.
 Trusted Keys can be 32 - 128 bytes (256 - 1024 bits).
 
+Trusted Keys usage: DCP
+-----------------------
+
+Usage::
+
+    keyctl add trusted name "new keylen" ring
+    keyctl add trusted name "load hex_blob" ring
+    keyctl print keyid
+
+"keyctl print" returns an ASCII hex copy of the sealed key, which is in format
+specific to this DCP key-blob implementation.  The key length for new keys is
+always in bytes. Trusted Keys can be 32 - 128 bytes (256 - 1024 bits).
+
 Encrypted Keys usage
 --------------------
 
@@ -426,3 +470,44 @@ string length.
 privkey is the binary representation of TPM2B_PUBLIC excluding the
 initial TPM2B header which can be reconstructed from the ASN.1 octed
 string length.
+
+DCP Blob Format
+---------------
+
+The Data Co-Processor (DCP) provides hardware-bound AES keys using its
+AES encryption engine only. It does not provide direct key sealing/unsealing.
+To make DCP hardware encryption keys usable as trust source, we define
+our own custom format that uses a hardware-bound key to secure the sealing
+key stored in the key blob.
+
+Whenever a new trusted key using DCP is generated, we generate a random 128-bit
+blob encryption key (BEK) and 128-bit nonce. The BEK and nonce are used to
+encrypt the trusted key payload using AES-128-GCM.
+
+The BEK itself is encrypted using the hardware-bound key using the DCP's AES
+encryption engine with AES-128-ECB. The encrypted BEK, generated nonce,
+BEK-encrypted payload and authentication tag make up the blob format together
+with a version number, payload length and authentication tag::
+
+    /*
+     * struct dcp_blob_fmt - DCP BLOB format.
+     *
+     * @fmt_version: Format version, currently being %1
+     * @blob_key: Random AES 128 key which is used to encrypt @payload,
+     *            @blob_key itself is encrypted with OTP or UNIQUE device key in
+     *            AES-128-ECB mode by DCP.
+     * @nonce: Random nonce used for @payload encryption.
+     * @payload_len: Length of the plain text @payload.
+     * @payload: The payload itself, encrypted using AES-128-GCM and @blob_key,
+     *           GCM auth tag of size AES_BLOCK_SIZE is attached at the end of it.
+     *
+     * The total size of a DCP BLOB is sizeof(struct dcp_blob_fmt) + @payload_len +
+     * AES_BLOCK_SIZE.
+     */
+    struct dcp_blob_fmt {
+            __u8 fmt_version;
+            __u8 blob_key[AES_KEYSIZE_128];
+            __u8 nonce[AES_KEYSIZE_128];
+            __le32 payload_len;
+            __u8 payload[];
+    } __packed;
-- 
2.35.3

