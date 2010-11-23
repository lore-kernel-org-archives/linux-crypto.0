From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v1.5 1/5] lib: hex2bin converts ascii hexadecimal string to
 binary
Date: Tue, 23 Nov 2010 18:43:14 -0500
Message-ID: <1290555794.2604.12.camel@localhost.localdomain>
References: <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Similar to the kgdb_hex2mem() code, hex2bin converts a string
to binary using the hex_to_bin() library call.

Changelog:
- Replace parameter names with src/dst (based on David Howell's comment)
- Add 'const' where needed (based on David Howell's comment)
- Replace int with size_t (based on David Howell's comment)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge E. Hallyn <serge@hallyn.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 include/linux/kernel.h |    1 +
 lib/hexdump.c          |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3f648d2..fbca217 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -419,6 +419,7 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 }
 
 extern int hex_to_bin(char ch);
+extern void hex2bin(u8 *dst, const char *src, size_t count);
 
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 5d7a480..b66b2bd 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -34,6 +34,22 @@ int hex_to_bin(char ch)
 EXPORT_SYMBOL(hex_to_bin);
 
 /**
+ * hex2bin - convert an ascii hexadecimal string to its binary representation
+ * @dst: binary result
+ * @src: ascii hexadecimal string
+ * @count: result length
+ */
+void hex2bin(u8 *dst, const char *src, size_t count)
+{
+	while (count--) {
+		*dst = hex_to_bin(*src++) << 4;
+		*dst += hex_to_bin(*src++);
+		dst++;
+	}
+}
+EXPORT_SYMBOL(hex2bin);
+
+/**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
-- 
1.7.2.2
