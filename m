From: Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] crypto: replace FSF address with web source in license notices
Date: Tue, 14 Nov 2017 10:25:15 +0100
Message-ID: <20171114092515.27010-1-martink@posteo.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:50676 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752436AbdKNJZb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Nov 2017 04:25:31 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id DEF9920B52
        for <linux-crypto@vger.kernel.org>; Tue, 14 Nov 2017 10:25:28 +0100 (CET)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A few years ago the FSF moved and "59 Temple Place" is wrong. Having this
still in our source files feels old and unmaintained.

Let's take the license statement serious and not confuse users.

As https://www.gnu.org/licenses/gpl-howto.html suggests, we replace the
postal address with "<http://www.gnu.org/licenses/>".

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 crypto/ablk_helper.c      | 4 +---
 crypto/camellia_generic.c | 3 +--
 crypto/cast5_generic.c    | 3 +--
 crypto/cast6_generic.c    | 3 +--
 crypto/simd.c             | 4 +---
 crypto/twofish_common.c   | 5 ++---
 crypto/twofish_generic.c  | 5 ++---
 crypto/xcbc.c             | 3 +--
 8 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/crypto/ablk_helper.c b/crypto/ablk_helper.c
index 1441f07d0a19..6e5d2f149b89 100644
--- a/crypto/ablk_helper.c
+++ b/crypto/ablk_helper.c
@@ -18,9 +18,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- * USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
index a02286bf319e..32ddd4836ff5 100644
--- a/crypto/camellia_generic.c
+++ b/crypto/camellia_generic.c
@@ -13,8 +13,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 /*
diff --git a/crypto/cast5_generic.c b/crypto/cast5_generic.c
index df5c72629383..66169c178314 100644
--- a/crypto/cast5_generic.c
+++ b/crypto/cast5_generic.c
@@ -16,8 +16,7 @@
 * any later version.
 *
 * You should have received a copy of the GNU General Public License
-* along with this program; if not, write to the Free Software
-* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+* along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
 
diff --git a/crypto/cast6_generic.c b/crypto/cast6_generic.c
index 058c8d755d03..c8e5ec69790e 100644
--- a/crypto/cast6_generic.c
+++ b/crypto/cast6_generic.c
@@ -13,8 +13,7 @@
  * any later version.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
 
diff --git a/crypto/simd.c b/crypto/simd.c
index 88203370a62f..208226d7f908 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -19,9 +19,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- * USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  */
 
diff --git a/crypto/twofish_common.c b/crypto/twofish_common.c
index 5f62c4f9f6e0..f3a0dd25f871 100644
--- a/crypto/twofish_common.c
+++ b/crypto/twofish_common.c
@@ -24,9 +24,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- * USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
  *
  * This code is a "clean room" implementation, written from the paper
  * _Twofish: A 128-Bit Block Cipher_ by Bruce Schneier, John Kelsey,
diff --git a/crypto/twofish_generic.c b/crypto/twofish_generic.c
index ebf7a3efb572..07e62433fbfb 100644
--- a/crypto/twofish_generic.c
+++ b/crypto/twofish_generic.c
@@ -23,9 +23,8 @@
  * GNU General Public License for more details.
  * 
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- * USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
  *
  * This code is a "clean room" implementation, written from the paper
  * _Twofish: A 128-Bit Block Cipher_ by Bruce Schneier, John Kelsey,
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index df90b332554c..25c75af50d3f 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -12,8 +12,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  *
  * Author:
  * 	Kazunori Miyazawa <miyazawa@linux-ipv6.org>
-- 
2.11.0
