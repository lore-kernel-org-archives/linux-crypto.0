Return-Path: <SRS0=Lfag=35=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A00C6C2BA83
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Feb 2020 04:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6732620714
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Feb 2020 04:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbgBIEWP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Feb 2020 23:22:15 -0500
Received: from mail01.vodafone.es ([217.130.24.71]:7054 "EHLO
        mail01.vodafone.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727585AbgBIEWP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Feb 2020 23:22:15 -0500
IronPort-SDR: pcGwNFTGskV+oIi7C96BD8pxD76R7f0dw6SUtiT4lX8iBMjnX0vBv1nmPCPMWQuGh3j2UI2Zx8
 vSNg5YINkHZQ==
IronPort-PHdr: =?us-ascii?q?9a23=3Am2UdVxbyDq2GccLna/tzF4L/LSx+4OfEezUN45?=
 =?us-ascii?q?9isYplN5qZr8+4bnLW6fgltlLVR4KTs6sC17OK9f2wEjJcqdbZ6TZeKccKD0?=
 =?us-ascii?q?dEwewt3CUYSPafDkP6KPO4JwcbJ+9lEGFfwnegLEJOE9z/bVCB6le77DoVBw?=
 =?us-ascii?q?mtfVEtfre9FYHdldm42P6v8JPPfQpImCC9YbRvJxmqsAndrMYbjZZtJ6oryh?=
 =?us-ascii?q?bEoXREduVZyGh1IV6fgwvw6t2/8ZJ+/Slcoe4t+9JFXa7nY6k2ULtUASg8PW?=
 =?us-ascii?q?so/sPrrx7DTQWO5nsYTGoblwdDDhbG4h/nQJr/qzP2ueVh1iaUO832Vq00Vi?=
 =?us-ascii?q?+576h3Uh/oiTwIOCA//WrKl8F/lqNboBampxxi347ZZZyeOfRicq/Be94RWG?=
 =?us-ascii?q?xMVdtTWSNcGIOxd4UBAeobPehGrIfzulQBogexCwS3GOPiyCNHimPq0aEmze?=
 =?us-ascii?q?gsFxzN0gw6H9IJtXTZtM/7O7kOUe+r1qnD0DXMb/RQ2Tfy9YPFdQghru+QXb?=
 =?us-ascii?q?1ua8rQx04vFwXKjliLsoPlOC6a2f4Msmic6epvS/ijhHIgqwF0uzWiwNonhI?=
 =?us-ascii?q?rRho8N1FzI6Cd0zJwoKdC2VEJ3e8CoHZRKuyyUN4Z7RN4pTXtytyYg0LIGvI?=
 =?us-ascii?q?a2fC0NyJs62RHSc+eHc42U4hL7U+aRPCt4iGpleL2hgxay9lCtyujmWcm11F?=
 =?us-ascii?q?ZKtDRKkt3Qun0CzRDT9M+HReZn8Uev3jaP0R7c5vtaLkAvjabbKpghzaAslp?=
 =?us-ascii?q?cLr0jPAy37lF/rgKKYakko4Pak5uv9brjoppKQL4p0hRv/MqQqlMy/G+M4Mg?=
 =?us-ascii?q?0WUmiD5+u8yKPs/Vf3QbVNiP02nbLUv4vdJcsGvKG4AghV0oA95BqlEzim19?=
 =?us-ascii?q?EYkWEdLF1ZYBKHk5TpO1bWLfD8DPe/hUmskThyy//aJL3gAo3NLmTEkLr6Y7?=
 =?us-ascii?q?Z95FBTyBApwdBc+Z1UELcBL+z3WkPrs9zYFBA5YESIxLPjCdNgxsYVQ3OXHq?=
 =?us-ascii?q?ixLqzfqxmL6/gpLu3KY5Ua6wzwM/w02/m7tXIllEVVQq6v0tNDcH2kE+55JE?=
 =?us-ascii?q?OWYWHmidcCOWgPtws6CuftjQvRfyRUYiOKUr4x/HkED4SpRdPbS5ygmqOG2i?=
 =?us-ascii?q?iTFJpab3JBDF3KGnDtIdbXE8wQYT6fd5cy2gcPUqKsHtcs?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FJbQAbiD9eeiMYgtlmHQEBAQkBEQU?=
 =?us-ascii?q?FAYF7AgGBPQKBVlINExKMZIZvgU0fg0OLaIEAgzOGCBOBZw0BAQEBARsaAgE?=
 =?us-ascii?q?BhECCRiQ8Ag0CAw0BAQUBAQEBAQUEAQECEAEBCwsLBCuFSkIBDAGBayKDcCA?=
 =?us-ascii?q?POUpMAQ4BhiIBATOlPIkBDQ0ChR6CTQQKgQiBGyOBNgIBAYwhGoFBP4EjIYI?=
 =?us-ascii?q?rCAGCAYJ/ARIBboJIglkEjVASIYk/mDCCRAR4lWuCOAEPiBGENQOCWA+BC4M?=
 =?us-ascii?q?dgwiBZ4RSgX6fWIQSV4Egc3EzGiOCHYEgTxgNnGICQIEXEAJPhDuGNoIyAQE?=
X-IPAS-Result: =?us-ascii?q?A2FJbQAbiD9eeiMYgtlmHQEBAQkBEQUFAYF7AgGBPQKBV?=
 =?us-ascii?q?lINExKMZIZvgU0fg0OLaIEAgzOGCBOBZw0BAQEBARsaAgEBhECCRiQ8Ag0CA?=
 =?us-ascii?q?w0BAQUBAQEBAQUEAQECEAEBCwsLBCuFSkIBDAGBayKDcCAPOUpMAQ4BhiIBA?=
 =?us-ascii?q?TOlPIkBDQ0ChR6CTQQKgQiBGyOBNgIBAYwhGoFBP4EjIYIrCAGCAYJ/ARIBb?=
 =?us-ascii?q?oJIglkEjVASIYk/mDCCRAR4lWuCOAEPiBGENQOCWA+BC4MdgwiBZ4RSgX6fW?=
 =?us-ascii?q?IQSV4Egc3EzGiOCHYEgTxgNnGICQIEXEAJPhDuGNoIyAQE?=
X-IronPort-AV: E=Sophos;i="5.70,420,1574118000"; 
   d="scan'208";a="315734664"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail01.vodafone.es with ESMTP; 09 Feb 2020 05:22:12 +0100
Received: (qmail 7825 invoked from network); 9 Feb 2020 00:49:06 -0000
Received: from unknown (HELO 192.168.1.163) (apamar@[217.217.179.17])
          (envelope-sender <peterwong@bodazone.com>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <linux-crypto@vger.kernel.org>; 9 Feb 2020 00:49:06 -0000
Date:   Sun, 9 Feb 2020 01:49:06 +0100 (CET)
From:   Peter Wong <peterwong@bodazone.com>
Reply-To: Peter Wong <peterwonghsbchk@gmail.com>
To:     linux-crypto@vger.kernel.org
Message-ID: <10428972.233521.1581209346692.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Greetings,
Please check the attached email for a buisness proposal to explore.
Looking forward to hearing from you for more details.
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

