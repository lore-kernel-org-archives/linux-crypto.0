Return-Path: <SRS0=hy52=AG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F371FC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jun 2020 13:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B201D20781
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jun 2020 13:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404888AbgFYNcB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jun 2020 09:32:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:46430 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404872AbgFYNcB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jun 2020 09:32:01 -0400
IronPort-SDR: Zk/P7R8GQla1XyYd22GboWd8AYX8GKVCqReYo8L25DxODrphngIqh4qHRT6w1j6OcSIzukLLe1
 DSP8NoQEKo0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="132323968"
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="132323968"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 06:32:00 -0700
IronPort-SDR: OajWDNyfmjo6D6PQCA1C72SzZxRfoh+Euyza0qcp2rYUa6r8ss2mTdNSBvJtAf3/2hSqyycyjQ
 CLpQ15sb4uKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="293877826"
Received: from unknown (HELO intel.com) ([10.223.74.178])
  by orsmga002.jf.intel.com with ESMTP; 25 Jun 2020 06:31:59 -0700
Date:   Thu, 25 Jun 2020 18:50:18 +0530
From:   Anshuman Gupta <anshuman.gupta@intel.com>
To:     linux-crypto@vger.kernel.org
Subject: [Query] crypto_akcipher_set_pub_key API usages.
Message-ID: <20200625132017.GA15183@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,
I am trying to import a public key extracted along with signature(RSA-SHA384) from my header.
When i tried to import the public key  buffer to algo crypto_akcipher_set_pub_key(), it fails
with -EBADMASG "ASN1: Unexpected tag" error msg.
My public in hex format and only contains modulus and exponent
(public key size is 3072 its).
As per DOCUMENTATION it should "BER encoded public key", as DER is just a stricter subset of BER encoding.
I had converted the my public key PEM file to DER format, and imported the key to crypto_akcipher_set_pub_key()
it still fails with EBADMSG.
After a lot of hidden trial i came to know it is the offset 24, which contian the data in which we are interested.

-------------------------------------------------
openssl asn1parse -in pub_pem.key  -offset 24
0:d=0  hl=4 l= 394 cons: SEQUENCE
4:d=1  hl=4 l= 385 prim: INTEGER :C94B36C902FCAFFE985CB39429CECADF51C56ED5B188870CEC5CC30D68BC19CE492D96EA7043F88C43336699CC0D96A71797B87FFE1B5FAE899995F676EADCC69E2DB6B4990E76C6F6AA7144420287FD086D67D2F29B85D06F52D8404CC108627D7E8CC9DC9F3ED1A402116AC879DAF540EEBCAF9C2109C2BE43FE0179876D23280C4E37EE3BFFA1F175BB28683823D4E408865E9A680EE23D70F0B45169E9F21BC6F435D751B81C9BE53C8F864166F439168E00900858C77946B1669CA9E1C7887A04DB866C99B35301DF6935A190780082BF0605B21319C9FBBD8DC44226FB2E3C33EC1FD439B0459E0D798A14167167799113A2790FD456B79AC017CE3635519713967EF1FA16B40744188AF9C9608597D161F1D2119FBB0821A5A4C687EEC9470B7C8C2350379285E2BB8CFE38CDD633377198099057E71F371FF0AB8BF59F0D897B91D60F89A9F7B8D27D6F2C6C0C3364E29328AC1F6A6D0298706FCDECF9B3C0A7059A5F65DB701EEB2C0F882F55E801218EA517EDFAB65CD47644B3BF
393:d=1  hl=2 l=   3 prim: INTEGER           :010001
-----------------------------------------------------

when i passed the DER formatted public key after offset 24,
crypto_akcipher_set_pub_key() has passed successfully.

I want to understand, why crypto_akcipher_set_pub_key() is expecting the
public key from a specific offset in DER formatted buffer. 
Is this offset is generic, can we caluclate this offset generically?
What is the meaning of "cons: SEQUENCE" of 394 bytes in above asn1 parse output?
I could see something similar "/* sequence of 265 bytes */" in a linux Kerenl crypto test vector,
https://elixir.bootlin.com/linux/latest/source/crypto/testmgr.h#325
Please provide help and pointers to understand this.

Thanks,
Anshuman Gupta.




