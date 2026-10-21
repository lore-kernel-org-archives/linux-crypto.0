Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.39
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792610756;
	b=BOQ4B7BbKRIV9cAt0W2Rln7OVnvoCgDdb4dh25EUaHFWF9bIxp7CFPct8ore8Va/rLmI
	 /xp9Wm2Hg076nfQwV/dkvnID5822I6n/7NXB7rCqM2v7uWO+FQCkrkK5iI/sCDZJmGBj5
	 ioJn3G/tIfn7+qeI1F+RmHAZdpZ1JBMwlhquf4RTm5m8BJk5kY7CpqsZzZ1+DmkKQhx4U
	 aeC5ItSQ7GAEC9RxGR1UvfPhZt85h+t1ZC4Qvxsj7tb1ZbIzsDsOnZvDzazeuBkaZamUs
	 sNpC0hhMuYeRfJRI+XL5aaT67biuYApvJ5/ZXFMrAllnmmXWU2g1JtwLfRxK4K8VYWg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792610756;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=5dV4DyJL2oznY8rJLIhMTKAJybKS890F0tOUvQ9dYRY=;
	b=Qpgm3/1C3UCvvlEUpAeN6Ygy5VchmBGDdrdggCCJWnJJG3/FHQUG91/K6R4jkzXBG6jW
	 LwkzLxGTR3uMX/TmqH918IhJDqyCzDiwlaUHdsRsn9yGxAoJu0HH0tmRdUy5eI9PfhuTw
	 6miNJOdYGRNpRR61ZWwYawyysTtyrQT86c3+SZzqkCCyj4/AiU4xvVFFhnlWoWrSxxkVQ
	 7wGk66sTbxzX58QMCd2r07kLS/CAzP+Z6Xn1Pqnn+AaQ4qwNG3m3D7+nsZJmvjddp9O3Y
	 gj0kCe6Z0fZ35U99cO5DpWB41b8no9dGY5jQr6Aks2jYhxiYbddbZS7EDHzv2L57hRA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5ZsXd+WJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.39
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012039.outbound.protection.outlook.com [52.101.43.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7AE606A31F
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 19:25:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C7AE606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5ZsXd+WJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PP1+zgi8J7h6KJuAdCXAZnRRTfg3xUG6x482riLuAv5qrab6/1/RaR3+2pjmBnBE0AuVoT9Mi3le/RrpfksCsD5IdR8i/UvH0KZvgcQXlftxScUidaSmMkgOLlaTAUOYVXfHOtHOOPn9YUENT1VH9TXUOIwYsrqYRe6aQW9Sbk2eJDKtxkIBYNDCAYE0FUGb/6IGoHPszki6S0s4EayOyvWEMcZY5gRyQYpfupbQRYKf9L/WaaTH24RkJ/wDuRtsUlbZrqsGFwUWLNUIM+EUk7h6q7xCYSpwe+FXsRO+m6/Ty7d/6E39RQU002IQmk+iLrgb+on4gHY9EQQtpmY1CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dV4DyJL2oznY8rJLIhMTKAJybKS890F0tOUvQ9dYRY=;
 b=iozkjqKpIZSbHfFKtS6pwzJCJ3U2w9J+WWeUVl/24EwSwh6WllpN59wA77uTe5h70W83N6ARVvtDoqSFtcEPgu02YrU497BVWlJrLkvnNBQFzAE1oo4opJqWiz8QP+Ok7LqjZ6mr/mZL6e+UdfWQG0by9+67mXeU2FJKZ0dON5zdpA2Jp+DKZF3PiFAeGdwj+oNHIjsrACA3zUzK7kOfKk4vJvqJqmtjtxW/PWoRPauYu0J3hTbQYczDhDzpnreB8dytVLqUWlVbiz1eA1wV5B0LqsvJjSh+uLu36VuEFs7gg5k5GKxLzZyXDYbAchZLKi8mhhdzWjXWSWLu7dORUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dV4DyJL2oznY8rJLIhMTKAJybKS890F0tOUvQ9dYRY=;
 b=5ZsXd+WJ41MumExxoy69DcYJef3QAZg3lVFrbXzKLF7QyCY7RgX3EsQZQjsYPK3b51arQTyI9tC2YG28f95LIgcvMbBQu47P9gY57sVLwmH1PjN1ZQzdpxjLKr64fKQ2MJykZlqC72fNsXDJ76Ae+kCcIzjfsE/Y62Uwfqj05Bs=
Received: from CH0PR03CA0333.namprd03.prod.outlook.com (2603:10b6:610:11a::7)
 by SA3PR12MB598757.namprd12.prod.outlook.com (2603:10b6:806:52d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 19:25:49 +0000
Received: from CH1PEPF0005BD61.namprd02.prod.outlook.com
 (2603:10b6:610:11a:cafe::e) by CH0PR03CA0333.outlook.office365.com
 (2603:10b6:610:11a::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.16 via Frontend Transport; Wed,
 21 Oct 2026 19:25:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0005BD61.mail.protection.outlook.com (10.167.244.250) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 19:25:49 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 21 Oct
 2026 14:25:49 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>, <pbonzini@redhat.com>
Subject: [PATCH v3 0/1] crypto: ccp - Make sev_cmd_mutex more granular
Date: Wed, 21 Oct 2026 14:15:16 -0500
Message-ID: <20261021192434.1924950-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD61:EE_|SA3PR12MB598757:EE_
X-MS-Office365-Filtering-Correlation-Id: 022873bc-0552-4158-fc62-08df2fa91d45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|82310400026|261021121427099003|56012099006|11063799006|261009223027099003|18002099003|10067099003|261021123027099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	XE7gEMis42Y94OqmQLGtI2Isz5p7vihnrn8Gc3MeAS2hNGDQSmRzNV7o9E42ZwDzEM+U2fDnYVR27xrKRceUG7XjCrY8YxTrXlUiF4VNlbdN5nCQAvMxw9YmaDWwMvN++BsvpCPFS/cnjxzZyVR7Y+nl6VYSmu49Jz5C4Yo/Wh8lpKxX1awVYv4Vl2ueCnVn9+Q9d1wpfSBwLU2IZch2Ws3rKFKaZCNxjGq70BFewwRZTiqLhfVnOWPh+bShGTKnKThYRTAyzSniQS7cxeWLer/4lp0u255UQY5jALOmkfzfyMstIKlQWOYeuOEJuSkXlWTLLrajlDhi+BxmLRGFowYN73PbQw1FG1r03ME2+9gy83YMC6UMf/16S6nu0Zmh4ej8JwcMlZ5+GRPdPzkkV//qiee3zEX4D6M7xmx1IuZjf2WkOOYys+41nkIR0lgJn5Tek3jY40FXnvg+NiIHrdrY/ka7Tgh/c1ml0JKKzJJN6+ZNuO8XAsN5iTvp6u2vSJXM43ZFXwOM7r3B+8/C8QP2bsjNInyB+0UDo8VBWNQYU8lVTFrfB19LpBcVGGsWk6/I0K6WxApMdoOdmImZnoxoKckb0PdmNqubqAeZyVvTpRfSbvBzTzj1+9bg2RoHY8sGThXT5xyQTUOoOPHC/g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(261021121427099003)(56012099006)(11063799006)(261009223027099003)(18002099003)(10067099003)(261021123027099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Duhe2V58ZyDGl3AJNV6APm0zvrXdHpaAv68K0aUCQNPeR72Io4OiDCAfbqgYNRlnUniXY2ovJoq+0y+MOt9RNJAh0/4nwbV1DOiQx3T08IVqtDU2Y84K9KRPhGDzEB1a6CsFtXNxBe0pPdWOi5Ok5IWwJAK5/dmjgA/ICHlamHF8O9nV8RXJo11w0SDjspL6Ft/wD/jWVwT/TBk5JqmmTqgrD3ojQP+NMp3oaxTGXxA7ebAQ+KQCFlhVodYeVLuFM0mK3AJHQB3zPmIwwGh9tOfz85EFGzXTCA0VwSuU5r/g01EfvE2IK+/PZVq9AmqBdAiT5VxG4vKUkixu7to9UGT1qioKPZKegt4KRffwb+5OZ9dBsn1Nyc/9T3VBtu+IHbIiKTWXPxu6YHq8j/VGbprJiSOSxvjzGgeT13B5u2pQp8H921DM3sPM5yXOY7un
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 19:25:49.6454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 022873bc-0552-4158-fc62-08df2fa91d45
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD61.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB598757

This patchset is also available at:

  https://github.com/amdese/linux/commits/ccp-mutex-rework-v3

and is based on cryptodev-2.6 master (178aff4cf425).

v1: https://lore.kernel.org/linux-crypto/20261014132145.1726322-1-michael.roth@amd.com/
v2: https://lore.kernel.org/linux-crypto/20261016041109.1778673-1-michael.roth@amd.com/
v3:
 - drop all unnecessary refactorings to make patches more appropriate for 7.4
   (Herbert, Sean)
 - retest CCP both with and without kvm/queue in-place conversion support
   present, re-verify no deadlocks/regressions. Testing done primarilly with
   the following kselftest:
     https://github.com/AMDESE/linux/commit/33ddcbd756b3db5bd2bd5737e48c9084e715cd38
 - rebase on latest cryptodev master (178aff4cf425)


OVERVIEW
--------

The current code makes very coarse usage of the sev_cmd_mutex; for SEV
firmware ioctls, it is essentially taken upon entry, and ends up wrapping
a lot of potentially time-consuming prep/cleanup work that may need to be
done before/after issuing the actual firmware call, which is the main
thing the mutex is meant to protect.

Additionally, some of that prep work involves
copy_from_user()/copy_to_user() calls which can generate page faults and
unecessarily lead to potential deadlock scenarios. No known case exists
in current upstream, but with the upcoming KVM/guest_memfd support for
in-place conversion of the same PFN between shared/private state (which
is currently targeted for kernel 7.4), a special fault handler is added
that could theoretically deadlock if a malicious user tries to use
guest_memfd pages as the source/target of target of said
copy_from_user()/copy_to_user() scenarios[1].

So this series is a prereq to enabling the above-mentioned KVM/guest_memfd
in-place conversion support on SNP-enabled hosts, as well as a cleanup
for SEV ioctls in general.

Thank you to Sean for suggesting this approach and Ackerley for wrangling
the changes into a (hopefully) presentable patchset.


REFERENCES
----------

[1] https://lore.kernel.org/kvm/asz8GKNO9aQANr5E@google.com/


Thanks!

-Mike


----------------------------------------------------------------
Michael Roth (1):
      crypto: ccp - Make usage of sev_cmd_mutex more granular

 drivers/crypto/ccp/sev-dev.c | 101 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 76 insertions(+), 25 deletions(-)

