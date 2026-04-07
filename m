Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1220C3A782D
	for <linux-crypto@vger.kernel.org>; Tue,  7 Apr 2026 10:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775556335; cv=fail; b=eb5PaFG1tfP/lEypaBs8Y2PAJoUa72SEpDhJJnWwaM473e0KFEZ/qpWN85QluU7QO2vrIdW/9OKsZw4Yw7aObEZTX657uQELCWfeZYd73cszGkS57py9MNpRZx3ej4upROrbR9pTeU878b2dzQc/FRDXVGWihXKKvQLQd1lsO+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775556335; c=relaxed/simple;
	bh=yavsXxAw41VrJpvOBMr6TyfMoIF4xNqnGlf6JGVtxgU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Y58qU9hV03N8c2LP5NgZaqpDEZiklnfvihJA3bRa/bQkZQjm8SHmo7BTlwoNAIxk8PHuKINDTRo8uunRmBmO3uyH6j6dkfI9M5qoH5DtePnwmS57vaBMDbBAlOc6uf8JDIyX89Q1k47oYXQblYMqOOv/M5q3W7dWu6BaIy+oKnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U0ZRnVih; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U0ZRnVih"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775556333; x=1807092333;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=yavsXxAw41VrJpvOBMr6TyfMoIF4xNqnGlf6JGVtxgU=;
  b=U0ZRnVihbXirPPOQQa9n7uYLtYCFfd3nrS6hfgHPrsmXtFtXDj8yRm6g
   PbiFbJt80bgoyFwf08I1oACCNJQyb0ir10hkXr/wKccRXwBpdybbkW+DE
   4q6rTz71xw/AwPc21duyrnQ3sddsC2kwV8lrGNeyqilBNqQ+dTIEGZOff
   ucuX7h7mnajkhIOkOKz5kOcGyo6RukypFhy7DQNMtQtIHdOS903nb1Kna
   atN+NtOZHECJGureA205mnewrf2NhBr2CG17cXxTXJmvq5RhwJZXPtHD3
   9qjd1zmQ408jDTlaiC/PJ9Ec+xmNYTBpuBmqxDid28HLpC08iWcJDudi2
   g==;
X-CSE-ConnectionGUID: 2AwBD8CdSS6DO6XmbygsgA==
X-CSE-MsgGUID: hkx4uxSlT9emo+0gSzN6dA==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="76587441"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="76587441"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 03:05:33 -0700
X-CSE-ConnectionGUID: 4c9Ni8xcS5+fgo6J6kjiAw==
X-CSE-MsgGUID: nOjPi/Z0QzKJlACql8edOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="232167575"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 03:05:32 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 03:05:31 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 7 Apr 2026 03:05:31 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.11) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 7 Apr 2026 03:05:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IorAolbgCILmZMbe0YKl470lEkHUafWHudHhCv2qyoRjJNiWhuf8Eo1ABHCq1lWkQwG1yPBOJ1qWfF5ABnjgXJV1BCifZM3v2312Kg2wmDUsrzNHClxWxNzkdc0pS1yEkfsP4dXBQs/A6JKWCmSim8CEuYHOK9QHWkpGgC/VaVsbaz5ggadbw1iobipWPWt6+CdRKZ1d4dkYVDJ3LX9xGAOxGr5s99vzPJwd0t0Bha8ITVf4TVx90XNn0mGKRRJ4df6h+oPGOujei8bc2GttWFAeTqGNXwsiL3BIEeb5BjxBTIF1+OIyiSDEg0bDb1mskqu0EtiqCZKzCXXMkdwu9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M2oSHqF8WwPs2LzZNw4OYrCMYtqh/lA2qvHO9HEHHXQ=;
 b=JkEhT9UVvLwmmGAzVE8RnEnUVw1LEs5+lMzTKB2Ia1c8DBZ+j3dVI/dntb6xLmLoFYqDwp+t+8rq1zl3OXnel5manYtadbbGIBflADMCCsCMv90zzw3r/iMr2u1U3tqD0G1vS/aEitMKUP7uzQSRucybumewQUiXT9oald/FWnmAcOtTx6siIwCE6dIoJBbWFLyyV3sLxK+ueE49d5jYjYMZASUdMDi9UdXdbRappOggeao6iNG78xzQqoklAjWVY4f23aLCW5JcVK/9bMI94eekzxIuQ+3D/JlGrNI3WZNt23zn8guCXLZaNju85dDFGfITiU6Tc82gVA+S9rxczg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6035.namprd11.prod.outlook.com (2603:10b6:208:376::13)
 by CH3PR11MB7794.namprd11.prod.outlook.com (2603:10b6:610:125::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Tue, 7 Apr
 2026 10:05:27 +0000
Received: from MN0PR11MB6035.namprd11.prod.outlook.com
 ([fe80::e715:746c:f3df:2498]) by MN0PR11MB6035.namprd11.prod.outlook.com
 ([fe80::e715:746c:f3df:2498%4]) with mapi id 15.20.9769.016; Tue, 7 Apr 2026
 10:05:27 +0000
From: Damian Muszynski <damian.muszynski@intel.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Damian Muszynski
	<damian.muszynski@intel.com>, Ahsan Atta <ahsan.atta@intel.com>, "Giovanni
 Cabiddu" <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix heartbeat error injection
Date: Tue, 7 Apr 2026 12:04:26 +0200
Message-ID: <20260407100443.8094-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.43.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VIZP296CA0019.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:2a8::6) To MN0PR11MB6035.namprd11.prod.outlook.com
 (2603:10b6:208:376::13)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6035:EE_|CH3PR11MB7794:EE_
X-MS-Office365-Filtering-Correlation-Id: 710500d5-945c-4733-9e51-08de948d3123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: oDgSEFv/iuqSIkay0y5t+RyE8ixQU5TWUjP8US48rQ24oz7Pv3tXe4GE4MA71d5gmjXVJKMoU8IM7e1eKJ0WWf814j9HSqMU9Cv4gAmtJYZ+ev4UJaDnsZRYfx2PP9B9b7WDAr62bLip39Nt0kjBh7ebc4po5nofDjoriR96dzIrvdYYaOqQ0A1FhaejRhQTsBHMr+IzTVCcmQm8hDRB9/5FxlCR3UeeznFFyqNcZfut0tmdw7u/BKjeKxwnJfi2C18n83rJU+P7J1N3R2Lus1w6ibbyDXgQcUgkynE+8mQYBOS4Qczxh+dL/AuKHLWmL1o3e/mbKwg3+bZoI3PzZf98jeYfqCDg5AGcV84xtMajop0+oZ8YFY/M0n2nVEfw+5jVVzCNKX+BUdt3RAkDsxbIdAXPyDn5KtQuYyQQj3dDadbwUfq913VVvSh141GYkOM3zqsli8ihsyDBRbSZvjcOlq4/bo3Yn6p95YKnb73DmAVPf3WNrjSR4QPzLgNOEmQhATRkfTqdWXlDskkusqOO/CpEYdOS7hnYxFju9uXuYh1SIGsY6HyWOOokMZV+trYVc9Tj93h4SkZ8nsCnvqRxBnbqm8s8Rf57tjMs9WmmfoN7gBeuwQJp/lVX0C2TuKndMPpdvPKBo5HLvqB3lawsWsj6pcUqVnkUmBVHRQz3J7/quDmo+Hzpu+rghr9VdGdELCEG0S5Q1qErwHXsJNxGzI2FUtp0OyC/bH0xbA8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6035.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gevsc6Xz+x2MEbBO/6hJHkskkSins40m6QqWosaFDMPdRAspfHC3dZtzWRIq?=
 =?us-ascii?Q?Hkg/dCcSAbOe5dLSBDX/uE4RjMbcgFfJOv5gdVHyLmOb0Je0LqTLnyVWanvY?=
 =?us-ascii?Q?eg/lDYhCigc5eH3ASb3C658Kfx1IWaUKYFnISXlFU79F9tL7rmVaCJKHrsau?=
 =?us-ascii?Q?maBrD4gmbDMW/NoX6V4snMLBcbuqIXad4D/WDs/ERe8NmKiWuOiVTzCpj5Qi?=
 =?us-ascii?Q?UxBNF/lOeHM5jh+x7uIcqwv4e+ltWM1i74zQG0Ft/chRE504qfNYTKc2lkfH?=
 =?us-ascii?Q?G3dHtyhzHvH3hNsueTGauZnj2V43AjnqVSsoI9lLAuz1kqFfyuF/BVniW2E0?=
 =?us-ascii?Q?eeAkbWSnPuAIUIYSv5gCM0vhN0h0u4sHMMPVUb3qpMb/5XaIhbzweLDJFPr1?=
 =?us-ascii?Q?VKktuDjpCE8zpZqrK8f0I1kM1lZriLHJ+9cIyJKxbAX6sr2I0W1omQ8l3seT?=
 =?us-ascii?Q?Osnd4NTRP7KRrk3+FFppeSxyHQuUylkJLLW4zKNfrsY2EuCGx3T7Tk+e/ql4?=
 =?us-ascii?Q?/ZAr7xxVRr0K+FtMty/EAErQyR6epXkqAyBnvYfRRoJydQr1rL1o3YVwOln0?=
 =?us-ascii?Q?Z7+iq5OIGOUK92/2bbPCF30Y02NUwlAIczlMCAgG2O4iNyjiEY7E9bk8xjSS?=
 =?us-ascii?Q?SnjISxSP9w6kbnJK+qf5KTg4Y/GGRMvK/vYP+tGT9mtasCYvYoBFYpEdsirb?=
 =?us-ascii?Q?AmoexFfDMMF78nENRno4TYJCZ+IY39I2KE8R6om99cYOS4OFIL1WwiS/3ilL?=
 =?us-ascii?Q?u6dqSgtcxXTa0aQOJdClCsbLY2n0vCY4mZSeHZ0N/k9gXDWr8MiGNZFsgVfY?=
 =?us-ascii?Q?ZF79ssP3aBki8M+t1nLDHJubg6Na2sW7fJuA8A+SvWSGibpW5MqXMfMXpqdb?=
 =?us-ascii?Q?uXRcBGwEWVULfJppShd+YSznMkJA+522mfRVY2+5+OuzNpj170znsDkD4bIX?=
 =?us-ascii?Q?+sEZi8wPPocT9yJ4TlikGkPhCdb22xcUNocEfRCHsqQJg5HPSSsYZHWPKLV4?=
 =?us-ascii?Q?Cf19W9vFNKgeT8EdpdMGKDAsAHQDEJr3yIIDim7TnQZNoweX6c3jRbqK5ZfL?=
 =?us-ascii?Q?tSXTqfHgsi8mC6+y5JONpz+aQhVooEN7xfHeQctNTyoCyglVdDnzlHITe9Jr?=
 =?us-ascii?Q?5yFQoYTlgjb8ul/bQarUZ/JpTDddTyeHtqs0qQTBvTyUGFPRy2SVb5+IoYW/?=
 =?us-ascii?Q?Fu3z5wWrvSxOk9HnPAJU1LGMxetXqROgpW5QoKi2E90XXlwDyvLDE4JiUnyk?=
 =?us-ascii?Q?oKQylseyYftc7J08hGZwfXy3ZKUdPryouwX9v2/sZ6Iwe3ci0oVVV5ybyNLw?=
 =?us-ascii?Q?6SpkYu3SuvbIPIZkJbDlrAaKyZKWofyoFoST8W1CmNR0y5HXZLNk286Jm3l6?=
 =?us-ascii?Q?eJwBK8gXYQRygqTzLL5Ys5HIt1PULxmJ70JmZoLouapTEMyVIO2s4fMK5xZ8?=
 =?us-ascii?Q?FsSddONlTYW5+3ijMUPydKV8oEuYJV5a2zUOG111u6mb8TCO1xHdcMNQzez0?=
 =?us-ascii?Q?JfqKCmMiWTmuby/IRV3ojaalLdCo/+1HOcjI5ZRcMDww4yHSVM7oFZ4tZ9Tz?=
 =?us-ascii?Q?0ydhBRnyrPrDKErfxqxh6b2bbb/swBq4Gb9Hjnz+u6EdMyLttJHCWjTKTG9g?=
 =?us-ascii?Q?4ztNqfCJ4mlBEjK5IBKQvaDTONEA2ZTc0qmrGrHKflIEUEPcle/zBE/uRpnN?=
 =?us-ascii?Q?UK4XZk0+UGPBm4ygVrlTbQv2/DbvU8zXJSf/3lWk0oCZNLqvVaIBE4tITy6i?=
 =?us-ascii?Q?zfPVb63ik931tE5q5Vyi1IM8tysQlQ8=3D?=
X-Exchange-RoutingPolicyChecked: aqYLJfIIWmZARP6V8iF7HIM5nmCwGMffswkYKhpnYQBHHPMEewiTNEjBjFlhCb8wfvcEgfAh6YR5/mYetoEhvwbkBCIkXO2OmMmrC+lX7NG/sjLjr+18GnrD8sIcl7B2LPkczr+YwLQTuxeyVnTwLWwFZ67vbfMBzSo0iS0W0098v+TP9MHKgx6dPWl1YJhDOL5o8MQpTnccI4dK+XWwAbJUyjd39FGExmbHXEy/8wGmn8bJRHYFRr/3UHyM7btStDc+Qu1dJdRQhGnER4zL35uT/VSUldwqzKnvbAGYJvzoULGceDug+RGa23M06Z7muxLz6ZTPeLchVs89kFaSWA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 710500d5-945c-4733-9e51-08de948d3123
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6035.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 10:05:27.0437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M6oGs3U8QkaZNULoyH9jfKF/3wag4fTRuxHJ6jUgVQDHE/Rv1f5mwvuq6tS5QPQNEr+EgnHwK6jYR7vPLKMHK++6bjd2x1ulmXBqFWBD6Zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7794
X-OriginatorOrg: intel.com

The current implementation of the heartbeat error injection uses
adf_disable_arb_thd() to stop a specific accelerator engine thread
from processing requests. This does not reliably prevent the device
from generating responses.

Fix the error injection by disabling the device arbiter through
exit_arb() instead. This properly simulates a device failure by
stopping all arbitration, which results in missing responses for
sent requests.

Remove the now unused adf_disable_arb_thd() function and its
declaration.

Fixes: e2b67859ab6e ("crypto: qat - add heartbeat error simulator")
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_common/adf_common_drv.h     |  1 -
 .../qat/qat_common/adf_heartbeat_inject.c     |  6 ++---
 .../intel/qat/qat_common/adf_hw_arbiter.c     | 25 -------------------
 3 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 7b8b295ac459..fb0fd46a79b0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -92,7 +92,6 @@ void adf_exit_aer(void);
 int adf_init_arb(struct adf_accel_dev *accel_dev);
 void adf_exit_arb(struct adf_accel_dev *accel_dev);
 void adf_update_ring_arb(struct adf_etr_ring_data *ring);
-int adf_disable_arb_thd(struct adf_accel_dev *accel_dev, u32 ae, u32 thr);
 
 int adf_dev_get(struct adf_accel_dev *accel_dev);
 void adf_dev_put(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c
index a3b474bdef6c..023c5f1e78b0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c
@@ -64,10 +64,8 @@ int adf_heartbeat_inject_error(struct adf_accel_dev *accel_dev)
 	if (ret)
 		return ret;
 
-	/* Configure worker threads to stop processing any packet */
-	ret = adf_disable_arb_thd(accel_dev, rand_ae, rand_thr);
-	if (ret)
-		return ret;
+	/* Disable arbiter to stop processing any packet */
+	hw_device->exit_arb(accel_dev);
 
 	/* Change HB counters memory to simulate a hang */
 	adf_set_hb_counters_fail(accel_dev, rand_ae, rand_thr);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
index f93d9cca70ce..dd9a31c20bc9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
@@ -99,28 +99,3 @@ void adf_exit_arb(struct adf_accel_dev *accel_dev)
 		csr_ops->write_csr_ring_srv_arb_en(csr, i, 0);
 }
 EXPORT_SYMBOL_GPL(adf_exit_arb);
-
-int adf_disable_arb_thd(struct adf_accel_dev *accel_dev, u32 ae, u32 thr)
-{
-	void __iomem *csr = accel_dev->transport->banks[0].csr_addr;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	const u32 *thd_2_arb_cfg;
-	struct arb_info info;
-	u32 ae_thr_map;
-
-	if (ADF_AE_STRAND0_THREAD == thr || ADF_AE_STRAND1_THREAD == thr)
-		thr = ADF_AE_ADMIN_THREAD;
-
-	hw_data->get_arb_info(&info);
-	thd_2_arb_cfg = hw_data->get_arb_mapping(accel_dev);
-	if (!thd_2_arb_cfg)
-		return -EFAULT;
-
-	/* Disable scheduling for this particular AE and thread */
-	ae_thr_map = *(thd_2_arb_cfg + ae);
-	ae_thr_map &= ~(GENMASK(3, 0) << (thr * BIT(2)));
-
-	WRITE_CSR_ARB_WT2SAM(csr, info.arb_offset, info.wt2sam_offset, ae,
-			     ae_thr_map);
-	return 0;
-}

base-commit: 8e7f93aab333eeac4b0327a2f14dca289d071b6a
-- 
2.43.0

