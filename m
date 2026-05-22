Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC2038C2A7
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 23:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779490912; cv=none; b=mmp0uPd5QMo41xN4ZXtmexk6v/ejvvXh0kWmRrJoGTZ00LtwYucDN3UzxKVfGWrRVImhuDdXMDabF8xoRYSSk3E+QEmynvU+AWBAcdfOqsDVIzJH8HjnVNK0ImYDLkg4sS+P3CwlJ/dlJESA7Z7x3e95sl6za3afG6k7tow59bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779490912; c=relaxed/simple;
	bh=zLuyHNJ9QkrKL+o3IkuZN3AWnRs1fdyM8NUHUTCahUA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rqBgLW39rPUsA+oigRO3lZQ3BvqPTanHjfjw0FZ3rZtL7HwKkwV19ZyqiPMgR+L4E8dWQlnpy/WagRJgXoayyvLO9g7VrsVa/FwehqDrjJnSQBzMmeiV/LIwEzYiXkLVpei/HWCuMOq1l2ALZ1L40Yqjn79zxuk7t1BC6oxAOkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Re3LuG8v; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Re3LuG8v"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43fe5574cb9so598208f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 16:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779490906; x=1780095706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VdPdyRKOtuD7Jq2T1rwTu6Wes+v7LpW2HMOrPNqb248=;
        b=Re3LuG8vaR1NwZUdM8I7+ExQIOS3iyPIjc/gDMLLncMuR0vJJ2HNIKYuMkqrHexs1z
         ddb6go7qQbMN0OZc6sd53nQweNKChG2y1pkEk6QAbCkGBkACXXv3yOkbiQF3gxLX4cjM
         OrhwBigWLUuwFqxVUhz65dve9OizYVqH+QqNpb2gsQvDy2N4fsVyIsF6TdiyXExovGlC
         PxUo0aKzeGkDd0xiwGxZLeybwwydWISsIWvVSMQbwS3WO5pqqPVRwzqMXID35o0RXvf0
         FQXc14WbTcMrs3fZC5pIhrnjtjtH2DRCM/SLRuvyAfeXuCaJON0mLApK9N5hV/DDFZ3t
         bzQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490906; x=1780095706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VdPdyRKOtuD7Jq2T1rwTu6Wes+v7LpW2HMOrPNqb248=;
        b=UVUfhBYLVMcUtdZmsk729RODMveNOQgQ4RajMqWsgYG2/nITwqhqxRUKLyPozV39TU
         U+Y+syEKnqQzXKAi/o3MUwJn+0Hkq6Za3OEpgAWByCOA+sFwaW5mtDkAuIWDbulevdLY
         1/G1vDK57g3AztOiB8c0v2CiYwRIwvrgMMMhDXyWWBy6z5lknLwBcr0m+cLGSfvtRdNu
         xcP03RW9B5KUi+Brqy4yUsc8wkyFnnedGG7SulkUH5zjfCaHZax4Fj6/Wre8PrvSd7Lj
         1t8AUmf8JlgXeYoYO5Sx1Ima6GQxYgcvWuokqCj8YxIR8xU3crEpW/Py6OIChC5Z9atA
         mtIw==
X-Gm-Message-State: AOJu0YxlQIkyLQbWL/YkNcdaq+wBOtum1NkGVD+xTUX6Szqt7hY8Nagb
	7HJnyP7vzzP6oDcp2KZWRvkaE3BOLJwwEmfucZhmZ3HKv8Sx5Jc9p+P9
X-Gm-Gg: Acq92OFROdNqrjsw685lErUkT/FvM5F7Ri+RE8OsFI4QzocbKOtoAXYcHcH7F3RDjg/
	eejgbWu+JWWx7eAoKPGnKh/g5La37i2R0AxSmLSsgw3zOdeff2OLWRIhQqyxuLMYcFRbmO3olkK
	XIzODWIdN1wtN7ohRegjfvsjUbzp1XSAORcfDIrOmhpCfeBHeKxyw2y4re7cSbE6fP1HHUbJFit
	MaIbalaS7oZM2ycNlxlkaA+Sd7VzEBDIARP4gMrWIQd4ef8Ylcg3uYZw6dpTQESxiO1MJwBSGc6
	bSnHb3G+KUh7mdzjv4ttKB2KxQeRbK+GI0gCQxHoLwEVYmd63l4SX8U1Y7zAmcxI6zRptcJLs9K
	vAiKrrtZWBkLCoHNW7dPzZbUTUXT9tmelySLVe1KwzaWoVSAG+1wKocgFDEjnkNRZgF2CtCatJ1
	D3YnRKv305Vy4fD6Af3o5LkT2XZ/AzLNd6RAgEA5xm9xA1Vjm2KCfpw5E/3Z6ilfI=
X-Received: by 2002:a05:600c:c4a3:b0:485:c456:5e4f with SMTP id 5b1f17b1804b1-490422529aemr38152485e9.0.1779490905632;
        Fri, 22 May 2026 16:01:45 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490456274ebsm67100265e9.15.2026.05.22.16.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 16:01:44 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	tudor.ambarus@linaro.org,
	ardb@kernel.org,
	linusw@kernel.org,
	krzk+dt@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v4 04/12] crypto: atmel-ecc - rename driver_data before moving it into atmel-i2c
Date: Fri, 22 May 2026 23:01:26 +0000
Message-Id: <20260522230134.32414-5-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260522230134.32414-1-l.rubusch@gmail.com>
References: <20260522230134.32414-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the local driver_data instance to atmel_i2c_mgmt in
preparation for moving the shared I2C client management
infrastructure into the atmel-i2c core driver in a subsequent
change.

No functional changes intended.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 39 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 005a9a3d919c..d12a9dbe45a7 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -28,7 +28,7 @@ static int atmel_ecc_kpp_refcnt;
 DECLARE_COMPLETION(atmel_ecc_unreg_done);
 static bool atmel_ecc_unreg_active;
 
-static struct atmel_ecc_driver_data driver_data;
+static struct atmel_ecc_driver_data atmel_i2c_mgmt;
 
 /**
  * struct atmel_ecdh_ctx - transformation context
@@ -214,14 +214,14 @@ static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
 	int min_tfm_cnt = INT_MAX;
 	int tfm_cnt;
 
-	spin_lock(&driver_data.i2c_list_lock);
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 
-	if (list_empty(&driver_data.i2c_client_list)) {
-		spin_unlock(&driver_data.i2c_list_lock);
+	if (list_empty(&atmel_i2c_mgmt.i2c_client_list)) {
+		spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 		return ERR_PTR(-ENODEV);
 	}
 
-	list_for_each_entry(i2c_priv, &driver_data.i2c_client_list,
+	list_for_each_entry(i2c_priv, &atmel_i2c_mgmt.i2c_client_list,
 			    i2c_client_list_node) {
 		if (!i2c_priv->ready)
 			continue;
@@ -239,7 +239,7 @@ static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
 		client = min_i2c_priv->client;
 	}
 
-	spin_unlock(&driver_data.i2c_list_lock);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
 	return client;
 }
@@ -334,11 +334,11 @@ static int atmel_ecc_probe(struct i2c_client *client)
 	i2c_priv = i2c_get_clientdata(client);
 	i2c_priv->ready = false;
 
-	spin_lock(&driver_data.i2c_list_lock);
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
-		      &driver_data.i2c_client_list);
+		      &atmel_i2c_mgmt.i2c_client_list);
 	i2c_priv->ready = true;
-	spin_unlock(&driver_data.i2c_list_lock);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
 	mutex_lock(&atmel_ecc_kpp_lock);
 	/*
@@ -352,12 +352,11 @@ static int atmel_ecc_probe(struct i2c_client *client)
 		timeout = wait_for_completion_timeout(&atmel_ecc_unreg_done,
 						      msecs_to_jiffies(2000));
 		mutex_lock(&atmel_ecc_kpp_lock);
-
 		if (timeout == 0) {
-			spin_lock(&driver_data.i2c_list_lock);
+			spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 			i2c_priv->ready = false;
 			list_del(&i2c_priv->i2c_client_list_node);
-			spin_unlock(&driver_data.i2c_list_lock);
+			spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 			mutex_unlock(&atmel_ecc_kpp_lock);
 
 			dev_err(&client->dev, "probe timed out, former driver instance not fully deregistered\n");
@@ -368,10 +367,10 @@ static int atmel_ecc_probe(struct i2c_client *client)
 	if (atmel_ecc_kpp_refcnt == 0) {
 		ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
 		if (ret) {
-			spin_lock(&driver_data.i2c_list_lock);
+			spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 			i2c_priv->ready = false;
 			list_del(&i2c_priv->i2c_client_list_node);
-			spin_unlock(&driver_data.i2c_list_lock);
+			spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 			mutex_unlock(&atmel_ecc_kpp_lock);
 
 			dev_err(&client->dev, "%s alg registration failed\n",
@@ -391,9 +390,9 @@ static void atmel_ecc_remove(struct i2c_client *client)
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 	bool trigger_unreg = false;
 
-	spin_lock(&driver_data.i2c_list_lock);
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	i2c_priv->ready = false;
-	spin_unlock(&driver_data.i2c_list_lock);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
 	/*
 	 * The Linux crypto core automatically blocks until all active
@@ -413,9 +412,9 @@ static void atmel_ecc_remove(struct i2c_client *client)
 	if (atomic_read(&i2c_priv->tfm_count))
 		wait_for_completion(&i2c_priv->remove_done);
 
-	spin_lock(&driver_data.i2c_list_lock);
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_del(&i2c_priv->i2c_client_list_node);
-	spin_unlock(&driver_data.i2c_list_lock);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
 	/*
 	 * The driver registers once an algorithm, but maintains a list of
@@ -459,8 +458,8 @@ static struct i2c_driver atmel_ecc_driver = {
 
 static int __init atmel_ecc_init(void)
 {
-	spin_lock_init(&driver_data.i2c_list_lock);
-	INIT_LIST_HEAD(&driver_data.i2c_client_list);
+	spin_lock_init(&atmel_i2c_mgmt.i2c_list_lock);
+	INIT_LIST_HEAD(&atmel_i2c_mgmt.i2c_client_list);
 	return i2c_add_driver(&atmel_ecc_driver);
 }
 
-- 
2.39.5

