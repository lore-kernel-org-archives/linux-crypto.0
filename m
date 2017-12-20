From: Cheah Kok Cheong <thrust73@gmail.com>
Subject: [PATCH 1/2] padata: Remove FSF address
Date: Thu, 21 Dec 2017 04:15:20 +0800
Message-ID: <1513800921-12452-1-git-send-email-thrust73@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thrust73@gmail.com
To: steffen.klassert@secunet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:43924 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755415AbdLTUQD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 15:16:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove FSF address otherwise checkpatch will flag my next patch.

Signed-off-by: Cheah Kok Cheong <thrust73@gmail.com>
---
 kernel/padata.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 57c0074..9d91909 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -14,10 +14,6 @@
  * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
 #include <linux/export.h>
-- 
2.7.4
