Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847B5C28CC5
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C1A364E60
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbhCCBiI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:38:08 -0500
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:61568
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343557AbhCBRw3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Mar 2021 12:52:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4Y6LNBDlgx/+Nf14Dqr/ib9EQ6dMGML4hvWviW4/u4kBjJfa+eczr8We8zhnCkacxKVVxwon9FzzICRNDAg3hn/it33sBRhg0oEPpnkgGFkh7wdFd7hSipO3tW2nzDxIw0HNG+hI6DBexGUZyiCLB9UT0eZEwzF62PPlz+Qx5YVLW0U3AqCazxjFEYqWTXN5BM7EBtY1gKiDpNvVb14E4zQERtqQeT9wgC2sCnTuj3ISm9bk6ZFg8bMtSAsYS/uWQdjPbx6Wr0TSdjTt1BPU8P65ACL0TaiRJHdFYe9G/NlNijRtQGtv+jHWQRivO8SkGzNJG+/yQQEVIWOccS1kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPiGhXMOMU808G5evOVuGXO2OprKWtKfiqjY68hctAo=;
 b=XQdsv8weP9OndmtWE5ASlKmBU2amdXm1qdjThSmY3+wbG0ZL4IXpwe3Ba42x8SyBPt4XuJv+EGXWrYJDU41Sy11RS28ex0grGeCJD5FJk7X3Bh7LflVXsVt++PTTadyYiIpazH0EagXspGgn87e3ef+ylMDpTPXXT1noK9/dr+S3fpb81Jovb3DxeF8Tj5c+g2FmCRa5p0dfo7GcFX1kmSZzSos9R8Ct49/y48SM0GIjGOYgV5Tmzz9KdA36VVrTETBlqd7NnQisy82wM2LPptSXbtgIjytv6gPhE9w17/5xer70WPJpkYNYXqmxrANPY0v1BoQrTMHDDwgU0qQfmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPiGhXMOMU808G5evOVuGXO2OprKWtKfiqjY68hctAo=;
 b=gRjtVmSMRXrdnsAx2WpJ4YgHn4Iktx5SzZWdJP0s8y+pdkOPmSq6/1ONMwFV0MzH/TjWq0y4VY3/JXjm1I9kDTkp8BokkOpQOOzyyLEubi7XZDt4LBG7wt78Ri2V4rcOgOGbg746E21BXfAd3qXJVdKZyv0D25n9HTl7SGV/vrk=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB6992.eurprd04.prod.outlook.com (2603:10a6:803:139::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Tue, 2 Mar
 2021 17:33:35 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::29a6:a7ec:c1d:47ba]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::29a6:a7ec:c1d:47ba%5]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 17:33:35 +0000
Subject: Re: CAAM RNG trouble
To:     Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>,
        Robert Hancock <robert.hancock@calian.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
References: <f9e4f7269c93306784e9106f4eb8a6c874973143.camel@pengutronix.de>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <88e8909b-268f-894e-10b1-67408e72d07f@nxp.com>
Date:   Tue, 2 Mar 2021 19:33:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <f9e4f7269c93306784e9106f4eb8a6c874973143.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM9P192CA0009.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::14) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (78.97.206.147) by AM9P192CA0009.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Tue, 2 Mar 2021 17:33:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e8b9f468-8027-472c-1c9c-08d8dda14eba
X-MS-TrafficTypeDiagnostic: VI1PR04MB6992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB699222A57613EBFF1A78F60298999@VI1PR04MB6992.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zINQbj4OY8RlYGEWKpP73gV7n3rEkregMPzFjUHb3xHcSqOyNWBSfdLKsRXEta4UQsDXqmbhf7HL/dXoc3OxkZMBEcq6ubEaMMVXTwxrzWCnUgKyyDC4r+++GbFBqW9nDqDEZAtqYntgXQ91CdVATDnLYdD+clHaGzotwmOj0aqZ1vtkA66wXyR08T4rNBBXoed2RjYTxnJx7bAD8p98UQ6rwqS9T+pnW2NpYk8JIymRDqjkcQDmevGXyamujzStJgbHRoFJJu14VT2/Uuxs/mrbsNNgKZppZpgjWXBzHbZ6OFDlkChL5WS/xLpmHFgNnL2/iy+jJ7hG/f9gWy2RB++UQR6Z1VZbBHOuTFXGDITUaDD6BLG2M2xWpHMlXA2HMwBStIXmkyhAu/S2VxvxydZ5ajPFOXzCi6BN+TDOx4bra/T+QYStZfSK5+abNHE6RQuSJqvY+GNS9GTjcysqX+vwo2pqTLrDHAORQ2nwR+WF1HMVWTWHi/3zntC/+7/ahoP5BZm/0AKyJiQJnj2jqrNzQQzIHC5ICQD2aSo98Rtnn39NZp/fhsHKibN648e5t49j3FWmiWQ1AOkpDoi+Ntc27ain4NIYS6Oi278JPXc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(54906003)(16526019)(26005)(110136005)(316002)(16576012)(186003)(2906002)(31696002)(7116003)(52116002)(83380400001)(53546011)(66476007)(66946007)(2616005)(8676002)(31686004)(478600001)(86362001)(36756003)(4326008)(6486002)(8936002)(3480700007)(956004)(66556008)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WXJzMUJEeER6dHVLMVh1azdRWUI0L0pFWnhlQVYxbWhDbWhYQ3A5bDZQRnda?=
 =?utf-8?B?MTNLMXlzMFFJaWxhdHJlOUw3TStKaUNsL1pzUGtIUkZpMkM4THg0VnBKZXJZ?=
 =?utf-8?B?eFRyek51ZW1pVVlOREJtMUZJc3gwTHlsY21oRmFFVktIVE9MNzhOcW5rV1JX?=
 =?utf-8?B?U3JxR2tDQ24zNHE5Vy9IYVRCU1I5M0g0MVBxWjY3ZmdHR0NWRDIvSjRrQVRR?=
 =?utf-8?B?ZWhWR1F3TEJiNDVRQ2VuUThJVWhhN29jSmlSOTJMUjlFczVtQkNTb0JQdHZm?=
 =?utf-8?B?bXQzTDNtOWNaWm1FeSswdEZZdjJldm05TGlTWm1Pb1prRWErNDJzaDQzL3FP?=
 =?utf-8?B?VHVvOXpvOG9uemdTUERkVmd5WDU2aDJudXpMUFJpa095b0MxNVR4S0JnMGNU?=
 =?utf-8?B?OWZVdHV1UTk2RUFPUDVDbEJRTi85UVdmaktkQStKSnM5QWNPVVprUDExK0la?=
 =?utf-8?B?ZmZHYUlPZFEwK0l2SHdtaXBaa0hRbExGQk16Y2tsMWVFendtOEtHQmM1UlVt?=
 =?utf-8?B?d2JkaUNtYVd2YTFMM040clNLTlZHaHZTenpCQ2Y3cDd2d0Qzc202d3B6QXRE?=
 =?utf-8?B?YVYzSXkzcFhDUE9ZT0F1WmhLbGV2Q2Nkb2xPS2RJZ3I5RjYzdWl1TXJQOTRQ?=
 =?utf-8?B?cTNIZDNvbDN4ZkFVM0tVT01FL2ZsQThZNmJheTVwcUF3RGxpZlBkVzRoZEQy?=
 =?utf-8?B?OUlNYVhCKzFEVFlJbTVhQmZOMGZvRjlHWWJscEdKUkVLRy9XVTFKK3VIUis1?=
 =?utf-8?B?ZDNwZzBjVW5WaXAxSUoxSWpscGhzWEk2UkxLVFVYVW0zbHdwMjV3YnF5TXEv?=
 =?utf-8?B?UG1wNjlLTmZkK2l2UE9NdXRxV1FwcVAvcE1uRk5KRlhxR0hYUS9iSFFFcVVT?=
 =?utf-8?B?TkZCRUdlaEh4UXpuR3RQQ0g0MWRiNnQwWHJaTzh4Yjk3T3cvRVBWMUd6QjFK?=
 =?utf-8?B?WWFCS3BrYld1eitvYVRzaFIxc2ZrME5nT1hZRUJDa3VIcXNDU2dSdlU0eUww?=
 =?utf-8?B?K2wwNXA1dmRiL05VckdMTVNsd2hYUm5pTmlRRXpsOTRXTGtuNHZLQlQ3SU40?=
 =?utf-8?B?M2YzcnFNaEhHU2tMQzE5bVFaZWJsRUZpdzcycXJndWdXRkVzUmsyMTlaZS9D?=
 =?utf-8?B?VUl0TDA4SWhaenJFcjFLdWVXdHhYNkVDQjJ5dldVSkJBTG1lRGg2QWxiUUE4?=
 =?utf-8?B?OEhBMExXQmNLaS92bjdFN0JkMHdHK2dFZDZUSnV2aThZL1ExTFhEamx1S3VP?=
 =?utf-8?B?YU5hazdxOXE0NUJCczBycDFFdUlPZERxcGRSM25mUnJvbDBKT3Y4aE9sWlh5?=
 =?utf-8?B?UFIybTI0dVYzQTB0UFB6VGF6TkMzdEhjRXN1OEtPenNkYUZrdDN4b3VORjk3?=
 =?utf-8?B?cE1VZFg4MmpxMVhEdXNxR09vNW05TUZJRGZyRnZOd1dtYUo1Qnh6MjhaMzJa?=
 =?utf-8?B?MmVONXdCSWwvOWV4UVZQZlM3bTJOcjNPaXlKZWVDYktjVnBmMXRzZ0VucDcr?=
 =?utf-8?B?Sk5mUEpQWElkeW9JdzBjUlNnK0tURmJ3N0lBTkhTNzNsU1NXMHNZME1XZFhL?=
 =?utf-8?B?ZW9Bc2E4YWhDT3U1VFY0cy94Y0IwN1ppeXRSL2xSZE5GbUhwa2ZxYjQxRFM5?=
 =?utf-8?B?OWVPeXlGWmVXNmkvQkgwWlIzYjdVQXM1bDRqMGt6Y1N4WWRPcVFWT1NJaldO?=
 =?utf-8?B?L05jZ0pTaWlPVk03ajFaVVQwaVZYdjJSU1ZObGhzSEFsa1JGSDZUbFJZUFh3?=
 =?utf-8?Q?CrzlyiOCRQjsWysMIXIlFC0pqohhG323WzzMp4e?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b9f468-8027-472c-1c9c-08d8dda14eba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 17:33:35.5946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7isq1UZsGhLvGznwccDu86/ur1eZqcJIJf9Ecn5+CvnMaV4LQ+aDtqfPR9j5GlPHbkvkgxvwPeJ9Yoe79ExJSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6992
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/14/2020 9:00 PM, Lucas Stach wrote:
> Hi all,
> 
> I've been looking into a CAAM RNG issue for a while, where I could need
> some input from people knowing the CAAM hardware better than I do.
> Basically the issue is that on some i.MX6 units the RNG functionality
> sometimes fails with this error:
> caam_jr 2101000.jr0: 20003c5b: CCB: desc idx 60: RNG: Hardware error.
> 
> I can tell that it is related to the entropy delay. On all failing
> units the RNG4 gets instantiated with the default entropy delay of
> 3200. If I dial up the delay to 3600 or 4000 the RNG works reliably. As
> a negative test I changed the initial delay to 400. With this change
> all units are able to successfully instantiate the RNG handles at an
> entropy delay of 2000 or 2400, but then reliably fail at getting random
> data with the error shown above. I guess the issue is related to
> prediction resistance on the handles, which causes the PRNG to be re-
> seeded from the TRNG fairly often.
> 
> Now I don't have a good idea on how to arrive at a reliably working
> entropy delay setting, as apparently the simple "are we able to
> instantiate the handle" check is not enough to actually guarantee a
> working RNG setup. Any suggestions?
> 
The successful instantiation of the RNG state handle(s) means that
the HW self-tests passed, but this doesn't mean RNG will work flawlessly.

A properly configured RNG should have a certain (very low) failure rate.
The logic in the caam rng driver is not checking this rate, since it's running
only once with a given configuration.
OTOH properly checking the RNG configuration would take some time, so it would
be better to run it offline. The "characterization" should also account for
temperature, voltage and process (fixed for a given SoC).

From this perspective, the caam rng driver should be updated to statically
configure the RNG with these offline-determined parameters.
Ideally we'd be able to use a single set of parameters to cover all SoCs
that have the same IP (RNG4 TRNG).
Unfortunately we're not there yet.

The situation became more visible after changing the caam rng driver to reseed
the PRNG before every request (practically making the PRNG function like a TRNG,
a hwrng framework requirement), since the HW self-tests are now running more
often then before.

Some questions that would give me more details about the exact issue you
and Robert are facing:

1. What SoC exactly are you running on?

2. How fast and how often is the RNG hardware error occurring?
Does this happen at boot time, only when stressing /dev/hwrng etc.?

3. Try dumping some of the RNG registers using below patch:

-- >8 --

Subject: [PATCH] crypto: caam - rng debugging

Dump RNG registers at hwrng.init time and in case descriptor returns
RNG HW error.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamrng.c |  9 ++++++++-
 drivers/crypto/caam/ctrl.c    | 29 +++++++++++++++++++++++++++++
 drivers/crypto/caam/ctrl.h    |  2 ++
 drivers/crypto/caam/regs.h    |  5 ++++-
 4 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 77d048dfe5d0..fc2192183696 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -16,6 +16,7 @@
 
 #include "compat.h"
 
+#include "ctrl.h"
 #include "regs.h"
 #include "intern.h"
 #include "desc_constr.h"
@@ -57,9 +58,12 @@ static void caam_rng_done(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct caam_rng_job_ctx *jctx = context;
 
-	if (err)
+	if (err) {
 		*jctx->err = caam_jr_strstatus(jrdev, err);
 
+		caam_dump_rng_regs(jrdev);
+	}
+
 	complete(jctx->done);
 }
 
@@ -199,6 +203,9 @@ static int caam_init(struct hwrng *rng)
 		return err;
 	}
 
+	dev_dbg(ctx->jrdev, "CAAM RNG - register status at hwrng.init time\n");
+	caam_dump_rng_regs(ctx->jrdev);
+
 	/*
 	 * Fill async buffer to have early randomness data for
 	 * hw_random
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ca0361b2dbb0..52db32b599aa 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -27,6 +27,35 @@ EXPORT_SYMBOL(caam_dpaa2);
 #include "qi.h"
 #endif
 
+void caam_dump_rng_regs(struct device *jrdev)
+{
+	struct device *ctrldev = jrdev->parent;
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
+	struct caam_ctrl __iomem *ctrl;
+	struct rng4tst __iomem *r4tst;
+	u32 rtmctl;
+
+	dev_dbg(jrdev, "RNG register dump:\n");
+
+	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
+	r4tst = &ctrl->r4tst[0];
+
+	dev_dbg(jrdev, "\trdsta = 0x%08x\n", rd_reg32(&r4tst->rdsta));
+
+	rtmctl = rd_reg32(&r4tst->rtmctl);
+	dev_dbg(jrdev, "\trtmctl = 0x%08x\n", rtmctl);
+	dev_dbg(jrdev, "\trtstatus = 0x%08x\n", rd_reg32(&r4tst->rtstatus));
+
+	/* Group of registers that can be read only when RTMCTL[PRGM]=1 */
+	clrsetbits_32(&r4tst->rtmctl, 0, RTMCTL_PRGM | RTMCTL_ACC);
+	dev_dbg(jrdev, "\trtscmisc = 0x%08x\n", rd_reg32(&r4tst->rtscmisc));
+	dev_dbg(jrdev, "\trtfrqmin = 0x%08x\n", rd_reg32(&r4tst->rtfrqmin));
+	dev_dbg(jrdev, "\trtfrqmax = 0x%08x\n", rd_reg32(&r4tst->rtfrqmax));
+	clrsetbits_32(&r4tst->rtmctl, RTMCTL_PRGM | RTMCTL_ACC, RTMCTL_ERR);
+
+}
+EXPORT_SYMBOL(caam_dump_rng_regs);
+
 /*
  * Descriptor to instantiate RNG State Handle 0 in normal mode and
  * load the JDKEK, TDKEK and TDSK registers
diff --git a/drivers/crypto/caam/ctrl.h b/drivers/crypto/caam/ctrl.h
index f3ecd67922a7..806f4563990c 100644
--- a/drivers/crypto/caam/ctrl.h
+++ b/drivers/crypto/caam/ctrl.h
@@ -11,4 +11,6 @@
 /* Prototypes for backend-level services exposed to APIs */
 extern bool caam_dpaa2;
 
+void caam_dump_rng_regs(struct device *ctrldev);
+
 #endif /* CTRL_H */
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index af61f3a2c0d4..dfc25a458a55 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -493,6 +493,7 @@ struct rngtst {
 /* RNG4 TRNG test registers */
 struct rng4tst {
 #define RTMCTL_ACC  BIT(5)  /* TRNG access mode */
+#define RTMCTL_ERR  BIT(12) /* TRNG error */
 #define RTMCTL_PRGM BIT(16) /* 1 -> program mode, 0 -> run mode */
 #define RTMCTL_SAMP_MODE_VON_NEUMANN_ES_SC	0 /* use von Neumann data in
 						     both entropy shifter and
@@ -526,7 +527,9 @@ struct rng4tst {
 		u32 rtfrqmax;	/* PRGM=1: freq. count max. limit register */
 		u32 rtfrqcnt;	/* PRGM=0: freq. count register */
 	};
-	u32 rsvd1[40];
+	u32 rsvd[7];
+	u32 rtstatus;		/* TRNG status register */
+	u32 rsvd1[32];
 #define RDSTA_SKVT 0x80000000
 #define RDSTA_SKVN 0x40000000
 #define RDSTA_PR0 BIT(4)
-- 
2.17.1
