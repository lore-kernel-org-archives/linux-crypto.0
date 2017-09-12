From: Lionel DEBIEVE <lionel.debieve@st.com>
Subject: Re: [PATCH 1/2] crypto: stm32 - Fix uninitialized data usage
Date: Tue, 12 Sep 2017 09:42:03 +0000
Message-ID: <b04df870-3c15-65ea-1f3e-d9a4338ff485@st.com>
References: <20170912093553.2580986-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="_002_b04df8703c1565ea1f3ed9a4338ff485stcom_"
Cc: Alexandre TORGUE <alexandre.torgue@st.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 "David S. Miller" <davem@davemloft.net>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170912093553.2580986-1-arnd@arndb.de>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

--_002_b04df8703c1565ea1f3ed9a4338ff485stcom_
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <C79138B4B6837740A54D90ABED7C0C55@st.com>
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

I've already push this fix for review last month, waiting the ack.

BR,

Lionel


On 09/12/2017 11:35 AM, Arnd Bergmann wrote:
> The error handling in stm32_hash_irq_thread passes
> uninitialized data into stm32_hash_finish_req, as gcc
> points out:
>
> drivers/crypto/stm32/stm32-hash.c: In function 'stm32_hash_irq_thread':
> drivers/crypto/stm32/stm32-hash.c:1088:2: error: 'err' may be used uninit=
ialized in this function [-Werror=3Dmaybe-uninitialized]
>
> I could not tell what data should be passed there instead,
> so this changes the code to always pass zero, making it
> well-defined, though possibly still wrong. Please check.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/crypto/stm32/stm32-hash.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm=
32-hash.c
> index b585ce54a802..3c23a23e9ee5 100644
> --- a/drivers/crypto/stm32/stm32-hash.c
> +++ b/drivers/crypto/stm32/stm32-hash.c
> @@ -1067,7 +1067,6 @@ static int stm32_hash_cra_sha256_init(struct crypto=
_tfm *tfm)
>   static irqreturn_t stm32_hash_irq_thread(int irq, void *dev_id)
>   {
>   	struct stm32_hash_dev *hdev =3D dev_id;
> -	int err;
>  =20
>   	if (HASH_FLAGS_CPU & hdev->flags) {
>   		if (HASH_FLAGS_OUTPUT_READY & hdev->flags) {
> @@ -1085,7 +1084,7 @@ static irqreturn_t stm32_hash_irq_thread(int irq, v=
oid *dev_id)
>  =20
>   finish:
>   	/*Finish current request */
> -	stm32_hash_finish_req(hdev->req, err);
> +	stm32_hash_finish_req(hdev->req, 0);
>  =20
>   	return IRQ_HANDLED;
>   }


--_002_b04df8703c1565ea1f3ed9a4338ff485stcom_
Content-Type: message/rfc822
Content-Disposition: attachment;
	creation-date="Tue, 12 Sep 2017 09:42:03 GMT";
	modification-date="Tue, 12 Sep 2017 09:42:03 GMT"
Content-ID: <DB54E7DE9933EB4A9735075306B3314D@st.com>

X-Mozilla-Keys: 
Received: from SFHDAG7NODE1.st.com (10.75.127.19) by SFHDAG7NODE2.st.com
 (10.75.127.20) with Microsoft SMTP Server (TLS) id 15.0.1178.4 via Mailbox
 Transport; Fri, 18 Aug 2017 15:55:43 +0200
Received: from SFHDAG7NODE1.st.com (10.75.127.19) by SFHDAG7NODE1.st.com
 (10.75.127.19) with Microsoft SMTP Server (TLS) id 15.0.1178.4; Fri, 18 Aug
 2017 15:55:43 +0200
Received: from epsilon.dmz-eu.st.com (10.75.127.46) by SFHDAG7NODE1.st.com
 (10.75.127.19) with Microsoft SMTP Server id 15.0.1178.4 via Frontend
 Transport; Fri, 18 Aug 2017 15:55:43 +0200
Received: from alpha.dmz-eu.st.com (alpha.dmz-eu.st.com [164.129.1.34])
	by epsilon.dmz-eu.st.com (STMicroelectronics) with ESMTP id 30E9933;
	Fri, 18 Aug 2017 13:55:43 +0000 (GMT)
Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by alpha.dmz-eu.st.com (STMicroelectronics) with ESMTPS id E505536;
	Fri, 18 Aug 2017 13:55:42 +0000 (GMT)
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
	by mx08-.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7IDsh5f014236;
	Fri, 18 Aug 2017 15:55:42 +0200
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mx08-.pphosted.com with ESMTP id 2cdfuydcbe-1;
	Fri, 18 Aug 2017 15:55:42 +0200
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751264AbdHRNzU (ORCPT <rfc822;lionel.debieve@st.com> + 1 other);
        Fri, 18 Aug 2017 09:55:20 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:33167 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750847AbdHRNzS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2017 09:55:18 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7IDsVss014205;
        Fri, 18 Aug 2017 15:54:38 +0200
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-.pphosted.com with ESMTP id 2cdfuydc44-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 18 Aug 2017 15:54:38 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id E42FE31;
        Fri, 18 Aug 2017 13:54:37 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag7node2.st.com [10.75.127.20])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 89E3226A2;
        Fri, 18 Aug 2017 13:54:37 +0000 (GMT)
Received: from localhost (10.75.127.50) by SFHDAG7NODE2.st.com (10.75.127.20)
 with Microsoft SMTP Server (TLS) id 15.0.1178.4; Fri, 18 Aug 2017 15:54:36
 +0200
From: Lionel Debieve <lionel.debieve@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	"Alexandre Torgue" <alexandre.torgue@st.com>, <linux-crypto@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@st.com>, Fabien Dessenne
	<fabien.dessenne@st.com>, Ludovic Barre <ludovic.barre@st.com>
Subject: [PATCH 1/1] crypto: stm32/hash - Remove uninitialized symbol
Date: Fri, 18 Aug 2017 15:54:01 +0200
Message-ID: <1503064441-19964-1-git-send-email-lionel.debieve@st.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG7NODE2.st.com
 (10.75.127.20)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:,, definitions=2017-08-18_05:,,
 signatures=0
Sender: <linux-crypto-owner@vger.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
X-CLX-Shades: MLX
X-CLX-Response: 1TFkXExwRCkx6FxsfGxEKWU0XZ2ZyEQpZSRcacRoQGncGHRxxGRMQHHcGGBo GGhEKWV4XaGNmEQpJRhdHQ0lYRU9GT0leWEVEQ0lZdUJFWV5PThEKQ04XdXx+bFN1SWlmRRp7Ul 0bUkh+XGZmXm98TEJJQn5gXm8RClhcFx8EGgQbGx4HHExOExhOG0kFGxoEHRoEHh8EGxoZEBseG
 h8aEQpeWRd7UGBwHxEKTVwXGBMYEQpMWhdobWhNexEKTU4XaBEKTEYXTWtrEQpDWhcYGhMEGxkY BBsSGgQcHREKQl4XGxEKRFgXGBEKRF4XHREKREkXGREKQkYXY3ATGUZoTF4THU0RCkJHF2hBcEB ybl57WHMcEQpCRRdneR4fcH8TaXJMbBEKQk4XbmhmHRJuY0VnSUkRCkJMF2RnYR1gTRwee0EaEQ
 pCbBdhGGdARQFAH2d+HBEKQkAXZ24cHmR9YXBgTUkRCk1eFxsRClpYFxsRCnBoF2BAZhNFeRkbc 0dvEBoRCnBoF2NHYBJ5fxJfSBl7EBoRCnBoF2xZUGJzQWtSHBkcEBoRCnBoF2ZuaGZiAURoE3l9 EBoRCnBoF3p6QmNBRFlBa2FGEBoRCnBsF2lzZm9och0bbRt4EBoRCnBMF2NzeRhrYHAFYUdTEB4
 SEQpwQxdrREdNS3hiEkZgaxAfHBEKbX4XGxEKWE0XSxEg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:,, definitions=2017-08-18_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=sapq_spampolicy_notspam policy=sapq_spampolicy score=0
 priorityscore=151 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=96 lowpriorityscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1707230000
 definitions=main-1708180223
Return-Path: linux-crypto-owner@vger.kernel.org
X-MS-Exchange-Organization-Network-Message-Id: 7548bda6-9d95-40fd-f462-08d4e640d181
X-MS-Exchange-Organization-AuthSource: SFHDAG7NODE1.st.com
X-MS-Exchange-Organization-AuthAs: Anonymous
MIME-Version: 1.0

Remove err symbol as this is not used in the thread context
and the variable is not initialized.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-hash.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index b585ce5..b34ee85 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1067,7 +1067,6 @@ static int stm32_hash_cra_sha256_init(struct crypto_tfm *tfm)
 static irqreturn_t stm32_hash_irq_thread(int irq, void *dev_id)
 {
 	struct stm32_hash_dev *hdev = dev_id;
-	int err;
 
 	if (HASH_FLAGS_CPU & hdev->flags) {
 		if (HASH_FLAGS_OUTPUT_READY & hdev->flags) {
@@ -1084,8 +1083,8 @@ static irqreturn_t stm32_hash_irq_thread(int irq, void *dev_id)
 	return IRQ_HANDLED;
 
 finish:
-	/*Finish current request */
-	stm32_hash_finish_req(hdev->req, err);
+	/* Finish current request */
+	stm32_hash_finish_req(hdev->req, 0);
 
 	return IRQ_HANDLED;
 }
-- 
2.7.4



--_002_b04df8703c1565ea1f3ed9a4338ff485stcom_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--_002_b04df8703c1565ea1f3ed9a4338ff485stcom_--
