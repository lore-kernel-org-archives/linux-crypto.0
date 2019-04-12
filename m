Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FACC10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 04:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A45020652
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 04:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbfDLE6d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 00:58:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:11639 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfDLE6c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 00:58:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Apr 2019 21:58:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,340,1549958400"; 
   d="scan'208";a="336090036"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 11 Apr 2019 21:58:29 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hEoGi-000Ebm-Ii; Fri, 12 Apr 2019 12:58:28 +0800
Date:   Fri, 12 Apr 2019 12:57:40 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     kbuild-all@01.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, dt@chelsio.com, atul.gupta@chelsio.com
Subject: Re: [crypto 3/4] crypto/chelsio/chtls: CPL for TLS client
Message-ID: <201904121250.wVjn3cFV%lkp@intel.com>
References: <20190409152441.11256-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409152441.11256-1-atul.gupta@chelsio.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Atul,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on crypto/master]

url:    https://github.com/0day-ci/linux/commits/Atul-Gupta/Inline-TLS-client-and-v6-support/20190412-034407
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'


sparse warnings: (new ones prefixed by >>)

   drivers/crypto/chelsio/chtls/chtls_cm.c:1333:42: sparse: incorrect type in assignment (different base types) @@    expected restricted __be32 [usertype] atid_status @@    got e] atid_status @@
   drivers/crypto/chelsio/chtls/chtls_cm.c:1333:42:    expected restricted __be32 [usertype] atid_status
   drivers/crypto/chelsio/chtls/chtls_cm.c:1333:42:    got int
>> drivers/crypto/chelsio/chtls/chtls_cm.c:54:6: sparse: symbol 'chtls_sock_release' was not declared. Should it be static?
   drivers/crypto/chelsio/chtls/chtls_cm.c:1155:17: sparse: expression using sizeof(void)
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1342:6: sparse: symbol 'chtls_handshake_work' was not declared. Should it be static?
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1362:6: sparse: symbol 'chtls_fix_pending_tx_buffers' was not declared. Should it be static?
>> drivers/crypto/chelsio/chtls/chtls_cm.c:1389:23: sparse: incorrect type in argument 1 (different address spaces) @@    expected struct dst_entry *dst @@    got struct dst_entry struct dst_entry *dst @@
   drivers/crypto/chelsio/chtls/chtls_cm.c:1389:23:    expected struct dst_entry *dst
   drivers/crypto/chelsio/chtls/chtls_cm.c:1389:23:    got struct dst_entry [noderef] <asn:4>*sk_dst_cache
   drivers/crypto/chelsio/chtls/chtls_cm.c:1500:40: sparse: incorrect type in argument 1 (different address spaces) @@    expected struct socket_wq *wq @@    got struct socket_wq struct socket_wq *wq @@
   drivers/crypto/chelsio/chtls/chtls_cm.c:1500:40:    expected struct socket_wq *wq
   drivers/crypto/chelsio/chtls/chtls_cm.c:1500:40:    got struct socket_wq [noderef] <asn:4>*sk_wq
   drivers/crypto/chelsio/chtls/chtls_cm.c:1501:25: sparse: cast to restricted __poll_t
   drivers/crypto/chelsio/chtls/chtls_cm.c:1548:16: sparse: expression using sizeof(void)
   drivers/crypto/chelsio/chtls/chtls_cm.c:1698:60: sparse: Using plain integer as NULL pointer
   drivers/crypto/chelsio/chtls/chtls_cm.c:2795:39: sparse: incorrect type in argument 1 (different address spaces) @@    expected struct dst_entry *dst @@    got struct dst_entry struct dst_entry *dst @@
   drivers/crypto/chelsio/chtls/chtls_cm.c:2795:39:    expected struct dst_entry *dst
   drivers/crypto/chelsio/chtls/chtls_cm.c:2795:39:    got struct dst_entry [noderef] <asn:4>*sk_dst_cache
   drivers/crypto/chelsio/chtls/chtls_cm.c:1801:22: sparse: context imbalance in 'chtls_recv_sock' - unexpected unlock

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
