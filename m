From: Stafford Horne <shorne@gmail.com>
Subject: [PATCH v2 2/2] kobject: Fix -Wstringop-truncation warning
Date: Mon, 25 Jun 2018 21:45:38 +0900
Message-ID: <20180625124538.21051-3-shorne@gmail.com>
References: <20180625124538.21051-1-shorne@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org, Stafford Horne <shorne@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180625124538.21051-1-shorne@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When compiling with GCC 9.0.0 I am seeing the following warning:

    In function ‘fill_kobj_path’,
	inlined from ‘kobject_get_path’ at lib/kobject.c:155:2:
    lib/kobject.c:128:3: warning: ‘strncpy’ output truncated before terminating nul copying as many bytes from a string as its length [-Wstringop-truncation]
       strncpy(path + length, kobject_name(parent), cur);
       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    lib/kobject.c: In function ‘kobject_get_path’:
    lib/kobject.c:125:13: note: length computed here
       int cur = strlen(kobject_name(parent));
		 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is not really an issue since the buffer we are writing to is
pre-zero'd and we have already allocated the buffer based on the
calculated strlen size and accounted for the terminating '\0'.
Just use memcpy() instead.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
---
 lib/kobject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 18989b5b3b56..e876957743c8 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -125,7 +125,7 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
 		int cur = strlen(kobject_name(parent));
 		/* back up enough to print this name with '/' */
 		length -= cur;
-		strncpy(path + length, kobject_name(parent), cur);
+		memcpy(path + length, kobject_name(parent), cur);
 		*(path + --length) = '/';
 	}
 
-- 
2.17.0
