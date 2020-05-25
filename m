Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAF6C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 20:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBE0B2070A
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 20:07:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=silexinside.onmicrosoft.com header.i=@silexinside.onmicrosoft.com header.b="llxV9xku"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390723AbgEYUHH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 16:07:07 -0400
Received: from mail-db5eur03hn2211.outbound.protection.outlook.com ([52.100.12.211]:3649
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390704AbgEYUHG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 16:07:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXwDPtpxWj5n0mZvuAK9ym40ogNunjKEF0QwERneWBSG3/dYysvb/m+P9B3a5M1aZjrKGjgNybmxL+SKCIFui4KxCnAm9Xza+4GKwTGWGQrNUFKcAzUKvyuYm3hcW/jHuklfYtO5JIJZizW5P7U6Xk2SgoOs8uTHwjo8X/MKYUp6rz5IuHWVKN06SzlrwNT0L6BowvsA8sa/FKiQGXSmLX5GKSYIDKhCc/M7OkYTCDia9ALNOfElIXZtQqcRWlwjvsR2/G6/fpykD7M6pPkoBbSNMnD96+LfwXlTr6y+wnv9/KaFA+ERWg8mXlna8khBdxMtQKc+6ejv7yescuTewQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ih7q/7P6622cN9o7wDRL95Ok5RQR//K0rJ+oOB8xG4Q=;
 b=V2CaKQiDtSd6sO6NEoLfvzdnQBzAFD+YP6mwWwySS9bn62NI9UgY60ectref3Pary0UMWp2cqFbdL/jPKmJBNV87IEFwlHhhYSl5iRv5KEA2Qrb0py1gjr7z4uJd+YIaiy/1/yCE/ZcimjEEN0edBJ07DePVy+fiDepaiH8IELoRjVb3AEpxKVhiGte6hB4U9tyBQoYpOf19BNhUS81IkzkTMeiqpB3aFXNB1CwTGW/PSl4pq+3Gn4b3oG0N4vyhl3ZhDg7L21uKMR9I62rrwmOpCEx62Ojh7eU+D+6NLIzJvVPbF+fZfRFSP3JYCQB7di6fKRv4NwobZBdsLLWhQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silexinsight.com; dmarc=pass action=none
 header.from=silexinsight.com; dkim=pass header.d=silexinsight.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silexinside.onmicrosoft.com; s=selector2-silexinside-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ih7q/7P6622cN9o7wDRL95Ok5RQR//K0rJ+oOB8xG4Q=;
 b=llxV9xkuKHRAoVmD0wJW+Xqo+7WDHaYKRDX6/XdBoRAUmkVHCzLeO8hFHFym9GYdQQwNtdgk2wZBpCwW+hH+DAb/5N/fHjcWEWZ3UqB9SzrF3nOKweYGM2MEW3mFUAAsaxzygGnRt1CNvZSlp4BMnno8gWkrR8Na+eQ0kKALgzM=
Authentication-Results: selenic.com; dkim=none (message not signed)
 header.d=none;selenic.com; dmarc=none action=none
 header.from=silexinsight.com;
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com (2603:10a6:20b:10d::15)
 by AM7PR09MB3735.eurprd09.prod.outlook.com (2603:10a6:20b:dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 20:06:59 +0000
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2]) by AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 20:06:59 +0000
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
Subject: [PATCH 1/3] dt-bindings: vendor-prefixes: Add Silex Insight vendor prefix
Date:   Mon, 25 May 2020 21:56:04 +0200
Message-Id: <20200525195606.2941649-2-olivier.sobrie@silexinsight.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525195606.2941649-1-olivier.sobrie@silexinsight.com>
References: <20200525195606.2941649-1-olivier.sobrie@silexinsight.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0033.eurprd05.prod.outlook.com (2603:10a6:205::46)
 To AM7PR09MB3621.eurprd09.prod.outlook.com (2603:10a6:20b:10d::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a02:a03f:a7df:f300:30f9:36cf:6713:51ae) by AM4PR05CA0033.eurprd05.prod.outlook.com (2603:10a6:205::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27 via Frontend Transport; Mon, 25 May 2020 20:06:59 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a02:a03f:a7df:f300:30f9:36cf:6713:51ae]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90cf7590-b44a-42c4-c45a-08d800e72e82
X-MS-TrafficTypeDiagnostic: AM7PR09MB3735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR09MB373503B14E31BEC93DFAF3A5F4B30@AM7PR09MB3735.eurprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KRHtMV7FqnNbYOb33yPf+vhpxuRtDRCYaJpQxZZJbW4EVqB9kW+C7/eGudgyKcNrF0kJpITnmjPvqmp4o6oCsLUD/dSlUtIPTRM1akQ+UyubeUR1J++AT/7PN1HXVD3WsgI/uBdtZSVnHiintkWoBajYZwZ6UW3yC4+b3s287NIk2Nc93OeOQ+9Wnacsr+lFOwgjI7EmKDXxZahtJJ6fq48tWmNqLBA9cRx53eQHrx9RbipZ+/5bQ6SSUER7CebWk3SNo7ZbNzi9kXRA0kjkKVi8FFdU+yNeCiLspV879ejQIG5BB6Z6Lqpr6aGYeS9eC7Qr5tHGVoXmG1sPxAyPtfbAoULA9PV4IIXDOWY8XrPCV97Sts7AIUvDhawyV2TDZe2ThDdhUygwnGCtAKCi6gnzxvzNSXIY1H9RN3NV8RHjnAAAsuA6aSHhZiVy98b5zkiE0YiecnwlT26Vhk4A7LC5mnn+4AGlQ9bAyIVXKxfUnxdxQpifEhviOyvBOHjfobHqiQNy30oT3R0NQ0WZpcIeSWk39wwz8ihTYl0eXEcZcL5tyYhls4cm2bLELzZsQYYa+5JVunKlEetbcxS4PbPHqbFmdvY6SttrESPiUKgJUtdTMJ6yikR5UpRTiDo738+wp5WCHTJx3mYkBdnQpqDF1qTv695duTpJZGXEDFzTv7HE6KTcBy0DdSxz+MC4fP6aEht7X+1yD+BxPS0dCdbay0uYq7TPBgRuWXkpIKU2rmIZP2aUEU/IDd2ygHwv6RxlM7u4LPceTa4EG6hDGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM7PR09MB3621.eurprd09.prod.outlook.com;PTR:;CAT:OSPM;SFTY:;SFS:(346002)(366004)(186003)(16526019)(66556008)(52116002)(2616005)(2906002)(66476007)(6496006)(107886003)(44832011)(4744005)(66946007)(54906003)(110136005)(508600001)(6486002)(8936002)(36756003)(1076003)(966005)(6666004)(4326008)(5660300002)(8676002)(86362001)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: R0n7anfORZBd3G3eOnG/gqwlYU1mWvhSAwZUH0k3qKdybTKA9gP6RevisZTLiRVhtm4eYhWB2Lj6sbZPfa0EYltsy4to9bTViSCDw2co74SDAaqpMr75rPyJeJVt1jlrdFT71w5yJB4xusf6nADiiXxx9kc4J6c0S6x4KUBKLnkMDzTbpv3SiEum0lolC1kUdSWZktZ03ow20nYW+6iHSl+G/zh1RjrM570VxiIYyvp36dLeYPnN1MNnsib5q2BisS44lJeTOfLXO3huEMmbTbjhDu9617VSZWfkoMYUmSuYgTeioikYngFNa2eE0k+L+ABBQK7sfjWCmSKPAcO/C2PENlm5p1lSrPM6Qe91FkvCzl+QIwDAbqTXIEHRFDlhWd6BqSAT3Bd9sZQ43g3iy5kpE4zLWRjVGQUKuqo4SvBOPPt8SNWe8TKX0hQ440086xnFzEagI1E7kzesRv8FxxJRERAbbI955gNhbO9kUpLo5zW+8zYaYRony/Ma+G2Q8YL2jwWhkQ6i7A0pnrH/d6EtnACEs2nlNVWpZp9cXmzwAi1OetCElZDwxEhClGrQ
X-OriginatorOrg: silexinsight.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90cf7590-b44a-42c4-c45a-08d800e72e82
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 20:06:59.2165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a02f6f9b-0f64-4420-b881-fca545d421d8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lD9dFY5uLoozp6GH4qDIx50AlDUKmhzGvpl4qGAurhAE6DV+XL3UaivODIpovAcb0JOQ9kAX+SJSlo9U64uv5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR09MB3735
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Silex Insight is a microelectronic company whose headquarter is located
in Belgium.
Web site of the company: https://www.silexinsight.com/

Signed-off-by: Olivier Sobrie <olivier.sobrie@silexinsight.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index d3891386d6710..45e555774be42 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -918,6 +918,8 @@ patternProperties:
     description: Silead Inc.
   "^silergy,.*":
     description: Silergy Corp.
+  "^silex-insight,.*":
+    description: Silex Insight
   "^siliconmitus,.*":
     description: Silicon Mitus, Inc.
   "^simtek,.*":
-- 
2.26.2

