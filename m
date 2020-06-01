Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BCAC433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 20:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91DE320776
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 20:28:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=silexinside.onmicrosoft.com header.i=@silexinside.onmicrosoft.com header.b="Z2R8x2z6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgFAU2K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jun 2020 16:28:10 -0400
Received: from mail-ve1eur02hn2208.outbound.protection.outlook.com ([52.100.10.208]:41954
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727959AbgFAU2J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jun 2020 16:28:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7/X5qaxlP7S+1nmk4XBr9V3vPMi857odwWkRDsy7rlhMT5fMl8/KA8tct0dcN7iOSJMa54Nv6dmX/GQfyvyl1VqVHQ8h0vDbpO9EOslpQyH7JceNTyQ3HCIwxhuJ2f9rPMyQQh0FRY9V2js7osHiyWCRuWTJ6GG7AeqncI25rcfeRI7m2h0/gCUlW6AUjIgxI6fN8obXJ9Oyq85j0BGEt0MHaolIGWb6sRCtzx1bVX3KOc/qifS1EnHxrasDnzQTzJeMnbXOS3+r2aexT1pia0aAJiZZN5P8OvXCEyH5Mn6tFTfJBlB/Twa/3Atf1v4sZ7cJ+HTnlJttI3F3WkYFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSjgepDZo/H8WzD+WevvqIcVOBZK0EG06tq5R0I+04c=;
 b=ekYVd3ciFRNCgc0dkUxly6aTvjTbxACVz8Ho9Tsh2e2iSBtT5GvOIzSuhovscEf0vR/ljDqAqD4qvTpjVwqSKG+e6HEHWgYe+tI00FVagL4ippnoUQEUb7HWQSnRJUH4BGPcGT8Ul7maPYi+ZWt+lb6nsCnIB59NAW5Lu4xfkoMJi2rWQzAbCsaqqKyw5lXFLhSf0yKB9+ZzjP2n3rAaT1JbK6Ibh+ZCrCZG/gwQlSYxin5sqJXPwGulHMi8ZZ81fqo5u2YjhCyG9h6Y6/g76TxFg6ofBeTTfCcbewSY9QGorYxLXmKQFbvYPMAF8E9dTs1jZJEPp3NETFlxRrGT2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silexinsight.com; dmarc=pass action=none
 header.from=silexinsight.com; dkim=pass header.d=silexinsight.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silexinside.onmicrosoft.com; s=selector2-silexinside-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSjgepDZo/H8WzD+WevvqIcVOBZK0EG06tq5R0I+04c=;
 b=Z2R8x2z6rilLm5SJ3aWpXv/rTeGxVUhEa4hamG3hyb27ckBoFL4qlNZoaOo9ezV8djRK3z195zJxdtd9lRZ/hqFtWHtN7UTkkNvxtHW2O/a0k+wILEuiH8VCQgwIgS1xrdP+2BDGdwcYCkgglg+cW5ro7HJ87ywxLaqAfy95yCA=
Authentication-Results: selenic.com; dkim=none (message not signed)
 header.d=none;selenic.com; dmarc=none action=none
 header.from=silexinsight.com;
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com (2603:10a6:20b:10d::15)
 by AM7PR09MB3957.eurprd09.prod.outlook.com (2603:10a6:20b:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Mon, 1 Jun
 2020 20:28:03 +0000
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2]) by AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2%8]) with mapi id 15.20.3045.024; Mon, 1 Jun 2020
 20:28:03 +0000
From:   Olivier Sobrie <olivier.sobrie@silexinsight.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Olivier Sobrie <olivier.sobrie@silexinsight.com>,
        Waleed Ziad <waleed94ziad@gmail.com>,
        sebastien.rabou@silexinsight.com
Subject: [PATCH v2 0/2] hwrng: add support for Silex Insight BA431
Date:   Mon,  1 Jun 2020 16:27:38 +0200
Message-Id: <20200601142740.443548-1-olivier.sobrie@silexinsight.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0026.eurprd03.prod.outlook.com
 (2603:10a6:208:14::39) To AM7PR09MB3621.eurprd09.prod.outlook.com
 (2603:10a6:20b:10d::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a02:a03f:a7df:f300:3173:2902:9670:18b) by AM0PR03CA0026.eurprd03.prod.outlook.com (2603:10a6:208:14::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Mon, 1 Jun 2020 20:28:03 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a02:a03f:a7df:f300:3173:2902:9670:18b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b3fb9d3-2f41-4036-a3bd-08d8066a491e
X-MS-TrafficTypeDiagnostic: AM7PR09MB3957:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR09MB3957DBDB57923B6524FC4B4CF48A0@AM7PR09MB3957.eurprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0421BF7135
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dQ3/EWIIq+eol/jLDuEqhadpmF1c3YHjPLJ7vuzkrJtleUhBM1WqDkM+k2uyvIuFarLg8GzPqYqn/+su1IDfyssy5NX1nirpAYlNHkGx6os6CB/z/mNzLN6mkFLgbKBHUcodgJISbfnjAbT5UPq4MlofQkHF0xAp5aV6BFm169tR/KENrIUksBUSEqh2iQd8Tr76U0tcsOUo1JuvLGakh6WqkCrPYkkX08Sci1HHvatAqITENLUJ315yoSnnGhYcrTaQSSvVyFYZr2TrjAXg/OIJmjSrkW37I4sD5NWUditqORcvVfQkoap0PsT/X4MJ6BruIxQ71tXD6qxuoOQq0PHGzAuZsPdrTY0TfG1hi6kwi701wndEEDVdI6UohRW9HhoAR/y/ztwEXp1h53j006gJEebx1GH8AO5bHy+5qcZ0ayxA+32L7tNZfDZoUfHSCQLaq6tbov1yJP3UN4OFBgj+ewOPt8hMCuXSHCQT8zRDAkyECbS2fZXJ389+GkCD9gHwZRIqDTmlgMXVQTX2TlqWhp3SsM9fgo7j/uJuXecfM2lC6TcL1p5vC8fcw65OZh5s7hm4YIeruMSOA1HEGVxKFZtctW4CVF0HdnZkgWUyKPJPbqSL4TJgCPtAzJw0lwwDaJbx2/pm7a0+nvVsCyh8BlLPKjX04niYWsSuo0JN8wx4nc9vj9UOqIK1dNeA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM7PR09MB3621.eurprd09.prod.outlook.com;PTR:;CAT:OSPM;SFTY:;SFS:(366004)(396003)(346002)(136003)(39830400003)(376002)(5660300002)(36756003)(6496006)(52116002)(66556008)(8936002)(1076003)(86362001)(16526019)(186003)(66476007)(66946007)(2616005)(8676002)(44832011)(107886003)(4326008)(508600001)(2906002)(316002)(6486002)(110136005)(54906003)(6666004)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: Lo+Hm03cfNQDXIdwhWxDG1DUJmv+fmEDOGntTC6xl3HMivIZYGCY60NZHlxRF476sChuTsF4/Db5ot5roS+iHoBPZve20DaBGIJfFjXZXphWiPz2pFIq0rwHqD+ZvOggYHRlhvMBKNchNCe2p+1sTq5SiDoFQPA74oMPYc/FMHHP+vrk8zGRMepY8vpg80VMw23aw2ZwNdlOGkE2ImYLSCfUfVDuV5pZZVIVo/CrIBucKBpFvQ4bIp7L2L+/BhQofxAp/md0TQhvXUCtToZ4P0jLVVVdF7aWfcXwj1gbB5ZAveCCX2ORZZxpDb/6o0N8IeLSBFYmNvmdGJVgIp8UPKIebFj7Rm/zi6HWQt7Hg+zKRfytIjqF2NM7Q+HgHZe0V2Wk7B//oM5b0y/VWyD7w1k8AFn0FsNUd3z/7nAfkYDj01uLlk8nq+OEKRwI7dMDsel10vdlP3Ei7/DwrwHkUVKDyxgVgTiAVb9yNOas82Ip69J3KGPoMyxIPkQtFW8DpW3obMrjPxCz2EufOq4JXVQw2E+RPWw9nUEQt3OQEyU=
X-OriginatorOrg: silexinsight.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b3fb9d3-2f41-4036-a3bd-08d8066a491e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2020 20:28:03.7085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a02f6f9b-0f64-4420-b881-fca545d421d8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PGCNH7MOOJIYLFDhO1TE+k9QOCiDpZ3TCYEIJtvyC+If6f6hhZPwLCGOnylo1p8wBDDvv1euaH5OUjMSaGEUlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR09MB3957
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello all,

This set of patches aims at introducing a linux hwrng driver for the
Silex Insight BA431 IP which is available for various FPGA.
This hardware is for instance present in Silex Insight Viper OEM boards.

The first patch documents the device tree bindings.
The second one contains the BA431 hwrng driver.

Olivier Sobrie (2):
  dt-bindings: rng: document Silex Insight BA431 hwrng
  hwrng: ba431-rng: add support for BA431 hwrng

 .../bindings/rng/silex-insight,ba431-rng.yaml |  36 +++
 drivers/char/hw_random/Kconfig                |  12 +
 drivers/char/hw_random/Makefile               |   1 +
 drivers/char/hw_random/ba431-rng.c            | 234 ++++++++++++++++++
 4 files changed, 283 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml
 create mode 100644 drivers/char/hw_random/ba431-rng.c

Changes in v2:
  - Dropped the first patch that has been applied by Rob.
  - Added Rob's review tag in the first patch.
  - Fixed copyright header.
  - Added missing endpoint and "If unsure, say Y" in the Kconfig like it is
    done for the other rng drivers.
  - Replaced the udelay() loop by readx_poll_timeout() in the driver.
  - Added Arnd's ack in the second patch.

-- 
2.26.2

