Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8449EC25B0D
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 04:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiHPEDG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 00:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiHPECm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 00:02:42 -0400
X-Greylist: delayed 302 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Aug 2022 17:30:30 PDT
Received: from relay1-n.mailbaby.net (relay1-n.mailbaby.net [206.72.200.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DFB34B4E1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Aug 2022 17:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbaby.net;
 q=dns/txt; s=bambino; bh=++TbyX+stIEBwEwxY7zJ5k/Kn4gxiK2b5lhdDkk2OEs=;
 h=from:subject:date:message-id:to:mime-version:content-type:content-transfer-encoding;
 b=TNYYQx8XnmCCUxT2+kG5bRNyK/sgFXrMx42LRmmTu/TDvCFQftzTw9BXKZwh1eaFLgXbKx4dJ
 kJN9UDh8Xkcv8Fc5mm/eb4xon6RjpdHjP5mO3qxy/F4HT4aqgnavylld1x+uFrLwIbyBoedMGFf
 BcBcjfhfE2VwQxrEUbxH+j0=
Received: from webhosting2008.is.cc ([174.138.177.194] webhosting2008.is.cc)
 (Authenticated sender: webhosting2008)
 by relay1-n.mailbaby.net (InterServerMTA) with ESMTPSA id 182a40a6b780006c1d.001
 for <linux-crypto@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 16 Aug 2022 00:25:22 +0000
X-Zone-Loop: fa42a15765568479a8c80bf94d3648bc0c0262753f0f
ARC-Authentication-Results: i=1;        relay3.mailbaby.net;    auth=pass
 smtp.auth=webhosting2008 smtp.mailfrom=alec@onelabs.com
ARC-Seal: i=1; s=detka; d=mailbaby.net; t=1660609522; a=rsa-sha256;
        cv=none;
        b=fYQk4RFGY42SJug3qLXZbU8AZD2HlvLZ5pgQCwU46KKmBygBRuWn79vWJoQELAaz8QAJeG
        firKj/pK2HKzqf5C0rHW3eFwULirNRNjpamUXhzvzdlvcJANl4Of7oRbsxKDwH5Kv81ebC
        JyXFFnHKcnrr64GPNiwE89ErhN2FO6fnwNr1YfWGH+sF3YoNpHIaN0vX7qQJD/bgziL32Q
        O/7O+XLQ6DAbWPBNMxXJ4tn0lMYQCU30vvrTBE7OQAtH14vdpJXKTN2GfzeA9nVllz/bcc
        mDb0LyYw2LhPf4AuQBeqBk8xSawKvj+Oj/ox4qc6BDCBAPnGmjmXGRp/iXBnTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailbaby.net;        s=detka; t=1660609522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:dkim-signature;
        bh=++TbyX+stIEBwEwxY7zJ5k/Kn4gxiK2b5lhdDkk2OEs=;
        b=LN8T6sMHdDqXy/fwD27yCNVQC69OHhTW8PeoChZW6mt9/pIvDt4vXVq4FoIzgWU5JwC4fb
        i0v4+JvaBd2jll3Nc6QgOa0Of2vohkcANTWygwyyxr0PTs4P+tCGG4d7dcnp6wHCTpyC4H
        lGRaAi2zLhvOQq1QGnJyG4sISwndM6Y5Ewna4laPel4TJ3bAEudl9VM4mQjFWSnCokvNX0
        3B12M351shS2odr4cIuOcruFApsSHz4+4qKzInT6ThrI/Et2+/WAkYHhHTBxKQqxxEqKfB
        iC3in9K7+oxWZjsZaUqO6YzYG+0kFF8yt9w4M0d/WUSQ1vh3teFrO2FrccKPGQ==
X-Originating-IP: [174.138.177.194]
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=onelabs.com
        ; s=default; h=Content-Transfer-Encoding:Content-Type:Message-ID:Subject:To:
        From:Date:MIME-Version:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=++TbyX+stIEBwEwxY7zJ5k/Kn4gxiK2b5lhdDkk2OEs=; b=iGI5aQ1MyD8vM2D+KjQY8Jcb1Q
        4l339tWBcp6eP0gBltyQx3Jet/Ckpf8M0Bq+tXOOsosxWqmfknpPZFBubILBbK0yxbjHZuT4ZaFkj
        XAbxNCknkHQ4hJ6Pa28g21oWBtiKUqaY+hsdrPBnxNGlZxJWtAHALdUhsbgyIIyZqd7r7gIP1qQJO
        RmZGx1MkXzrJEr9/0zwC2RhIX1iWVHuOT1s7Za5MFrsagcWMhGj00Qp0GLPwypOxxdCHUlihNgbEi
        hXc9ULjGAk/TO49VrsZqWSM+t7HfJ/6xvIZR+5bP4C2M9tHUgwytLWmwEpfyshiuubtYS9zPEbSUM
        QDCw/5GA==;
Received: from [::1] (port=50850 helo=webhosting2008.is.cc)
        by webhosting2008.is.cc with esmtpa (Exim 4.95)
        (envelope-from <alec@onelabs.com>)
        id 1oNkOX-00BUsu-SN
        for linux-crypto@vger.kernel.org;
        Mon, 15 Aug 2022 20:25:22 -0400
MIME-Version: 1.0
Date:   Mon, 15 Aug 2022 19:25:21 -0500
From:   Alec Ari <alec@onelabs.com>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: Make FIPS_SIGNATURE_SELFTEST depend on CRYPTO_FIPS
User-Agent: Roundcube Webmail/1.5.2
Message-ID: <7a7256a76002583dc12ab84953aab59a@onelabs.com>
X-Sender: alec@onelabs.com
Organization: ONE Labs
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-From-Rewrite: unmodified, already matched
X-AuthUser: alec@onelabs.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

 From: Alec Ari <alec@onelabs.com>
Date: Mon, 15 Aug 2022 19:13:12 -0500
Subject: crypto: Make FIPS_SIGNATURE_SELFTEST depend on CRYPTO_FIPS

Would running FIPS selftests be necessary if FIPS is disabled?

Signed-off-by: Alec Ari <alec@onelabs.com>
---
  crypto/asymmetric_keys/Kconfig | 1 +
  1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/Kconfig 
b/crypto/asymmetric_keys/Kconfig
index 3df3fe4ed..562bbd774 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -81,6 +81,7 @@ config FIPS_SIGNATURE_SELFTEST
           This option causes some selftests to be run on the signature
           verification code, using some built in data.  This is required
           for FIPS.
+       depends on CRYPTO_FIPS
         depends on KEYS
         depends on ASYMMETRIC_KEY_TYPE
         depends on PKCS7_MESSAGE_PARSER
-- 
2.37.2
