From: Stafford Horne <shorne@gmail.com>
Subject: [RFC PATCH 2/2] kobject: Fix -Wstringop-truncation warning
Date: Sat, 23 Jun 2018 11:07:53 +0900
Message-ID: <20180623020753.27266-3-shorne@gmail.com>
References: <20180623020753.27266-1-shorne@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de,
        linux-crypto@vger.kernel.org, Stafford Horne <shorne@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180623020753.27266-1-shorne@gmail.com>
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

This is pointing out a bug that the strncpy limit is the source string not the
destination buffer remaining length.  Fix it.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Stafford Horne <shorne@gmail.com>
---
 lib/kobject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 18989b5b3b56..15338e5a96f2 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -125,7 +125,7 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
 		int cur = strlen(kobject_name(parent));
 		/* back up enough to print this name with '/' */
 		length -= cur;
-		strncpy(path + length, kobject_name(parent), cur);
+		strncpy(path + length, kobject_name(parent), length);
 		*(path + --length) = '/';
 	}
 
-- 
2.17.0
