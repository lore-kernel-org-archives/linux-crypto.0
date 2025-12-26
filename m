Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16892253B0;
	Fri, 26 Dec 2025 16:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766765015; cv=none; b=k7kXGT0cW+oFPvEy7IZq7+rEjL6nQe46qpIu4Svk0MC/3l6YxTurNHVoJFwp9sh9A8X8g/9hR8BbHxluLhlEwnI7QRjknf7xJSl0yCkclnkFA7mutL2Bpot29yc54mUI4OfoZIOY1MwgNmFeZQEutS4xR3WabgxmqH2rwfXXt6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766765015; c=relaxed/simple;
	bh=UfXbdxumnkgYTp06Ua/eaMTHXEnLQT/C7e1P+oUJkTo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=LgFO58Jgejrb3FkcCQcyuk+agFBeqOgMMj4S9E/u27mkH4MFUp5uzPNDDHpMIdd7Z4kULb9kvm+J70JoQ3z+1JmEQTdMTYblJdFM2hdzLLVhZWIplg4rU2Nfyw1IaCAmOTQ2ZlRIZreP1OZXMYNh6Fm5wYfXBO7uV2ZxiUI3eDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=FJzZp5Nv; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="FJzZp5Nv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1766765004;
	bh=UfXbdxumnkgYTp06Ua/eaMTHXEnLQT/C7e1P+oUJkTo=;
	h=From:Date:Subject:To:Cc:From;
	b=FJzZp5Nv/ey3TBO4KopS5XGMLn53oMKEySdiOyCLAiXe8cMtkI2fBxwKbS+y418+y
	 OQ0+EH/E8xawxJt9CgbosC6TrrIBPyG9gR34Xb7kNQgqhxvZxlDZ4usp2/K+PqzMFa
	 g9nY3LfZmm65VJCfWAI/u2IqBab/RnqnhbktF818=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Fri, 26 Dec 2025 17:03:18 +0100
Subject: [PATCH] padata: Constify padata_sysfs_entry structs
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251226-sysfs-const-attr-padata-v1-1-8f1cf55bd164@weissschuh.net>
X-B4-Tracking: v=1; b=H4sIAMWxTmkC/x3MTQqEMAxA4atI1gZs8Gecq4iLWKNmU6Upw4h4d
 4vLb/HeBSZRxeBbXBDlp6Z7yHBlAX7jsArqnA1UUeOIWrTTFkO/B0vIKUU8eObEWHf+I31PXTU
 5yPURZdH/ex7G+34ADT/v9mkAAAA=
X-Change-ID: 20251226-sysfs-const-attr-padata-47c8e99270b1
To: Steffen Klassert <steffen.klassert@secunet.com>, 
 Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766765004; l=3678;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=UfXbdxumnkgYTp06Ua/eaMTHXEnLQT/C7e1P+oUJkTo=;
 b=BT1Y8fNRbmFRY4jLJOExqnXjpP3mgb7fEHHdbwkCAEdJXsfOIQ8KcBZYcfWgTTuVrTZ8EOExT
 fLkBC7CVfiVAcuCRwzPnEJ5V69FcTdruE47tC0k+HyCRmTF0/yy1nNg
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

These structs are never modified.

To prevent malicious or accidental modifications due to bugs,
mark them as const.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 kernel/padata.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index aa66d91e20f9..db7c75787a2b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -819,7 +819,7 @@ static void __padata_free(struct padata_instance *pinst)
 #define kobj2pinst(_kobj)					\
 	container_of(_kobj, struct padata_instance, kobj)
 #define attr2pentry(_attr)					\
-	container_of(_attr, struct padata_sysfs_entry, attr)
+	container_of_const(_attr, struct padata_sysfs_entry, attr)
 
 static void padata_sysfs_release(struct kobject *kobj)
 {
@@ -829,13 +829,13 @@ static void padata_sysfs_release(struct kobject *kobj)
 
 struct padata_sysfs_entry {
 	struct attribute attr;
-	ssize_t (*show)(struct padata_instance *, struct attribute *, char *);
-	ssize_t (*store)(struct padata_instance *, struct attribute *,
+	ssize_t (*show)(struct padata_instance *, const struct attribute *, char *);
+	ssize_t (*store)(struct padata_instance *, const struct attribute *,
 			 const char *, size_t);
 };
 
 static ssize_t show_cpumask(struct padata_instance *pinst,
-			    struct attribute *attr,  char *buf)
+			    const struct attribute *attr,  char *buf)
 {
 	struct cpumask *cpumask;
 	ssize_t len;
@@ -853,7 +853,7 @@ static ssize_t show_cpumask(struct padata_instance *pinst,
 }
 
 static ssize_t store_cpumask(struct padata_instance *pinst,
-			     struct attribute *attr,
+			     const struct attribute *attr,
 			     const char *buf, size_t count)
 {
 	cpumask_var_t new_cpumask;
@@ -880,10 +880,10 @@ static ssize_t store_cpumask(struct padata_instance *pinst,
 }
 
 #define PADATA_ATTR_RW(_name, _show_name, _store_name)		\
-	static struct padata_sysfs_entry _name##_attr =		\
+	static const struct padata_sysfs_entry _name##_attr =	\
 		__ATTR(_name, 0644, _show_name, _store_name)
-#define PADATA_ATTR_RO(_name, _show_name)		\
-	static struct padata_sysfs_entry _name##_attr = \
+#define PADATA_ATTR_RO(_name, _show_name)			\
+	static const struct padata_sysfs_entry _name##_attr =	\
 		__ATTR(_name, 0400, _show_name, NULL)
 
 PADATA_ATTR_RW(serial_cpumask, show_cpumask, store_cpumask);
@@ -894,7 +894,7 @@ PADATA_ATTR_RW(parallel_cpumask, show_cpumask, store_cpumask);
  * serial_cpumask   [RW] - cpumask for serial workers
  * parallel_cpumask [RW] - cpumask for parallel workers
  */
-static struct attribute *padata_default_attrs[] = {
+static const struct attribute *const padata_default_attrs[] = {
 	&serial_cpumask_attr.attr,
 	&parallel_cpumask_attr.attr,
 	NULL,
@@ -904,8 +904,8 @@ ATTRIBUTE_GROUPS(padata_default);
 static ssize_t padata_sysfs_show(struct kobject *kobj,
 				 struct attribute *attr, char *buf)
 {
+	const struct padata_sysfs_entry *pentry;
 	struct padata_instance *pinst;
-	struct padata_sysfs_entry *pentry;
 	ssize_t ret = -EIO;
 
 	pinst = kobj2pinst(kobj);
@@ -919,8 +919,8 @@ static ssize_t padata_sysfs_show(struct kobject *kobj,
 static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
 				  const char *buf, size_t count)
 {
+	const struct padata_sysfs_entry *pentry;
 	struct padata_instance *pinst;
-	struct padata_sysfs_entry *pentry;
 	ssize_t ret = -EIO;
 
 	pinst = kobj2pinst(kobj);

---
base-commit: ccd1cdca5cd433c8a5dff78b69a79b31d9b77ee1
change-id: 20251226-sysfs-const-attr-padata-47c8e99270b1

Best regards,
-- 
Thomas Weißschuh <linux@weissschuh.net>

